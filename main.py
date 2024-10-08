from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, relationship
from sqlalchemy import create_engine, Column, Integer, String, TIMESTAMP, Boolean, ForeignKey, Float
from datetime import datetime
from passlib.context import CryptContext


pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
DATABASE_URL = "mysql+pymysql://root:@localhost:3306/just_plug"
engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()

class User(Base):
    __tablename__ = 'users'

    id = Column(Integer, primary_key=True, index=True)
    username = Column(String(255), unique=True, nullable=False)
    password = Column(String(255), nullable=False)
    create_at = Column(TIMESTAMP, nullable=False, default=datetime.utcnow)
    
    details = relationship("UserDetail", back_populates="user", uselist=False)
    
class UserDetail(Base):
    __tablename__ = 'users_details'

    id = Column(Integer, primary_key=True, index=True)
    users_id = Column(Integer, ForeignKey('users.id'), nullable=False)
    name = Column(String(255), nullable=False)
    devices_id = Column(Integer, nullable=True)

    user = relationship("User", back_populates="details")


class Device(Base):
    __tablename__ = 'devices'

    id = Column(Integer, primary_key=True, index=True)
    device_name = Column(String(255), nullable=False)
    current_value = Column(Integer, nullable=False)
    device_status = Column(Boolean, nullable=False)
    firmware_version = Column(String(255), nullable=True)
    create_at = Column(TIMESTAMP, nullable=False, default=datetime.utcnow)

    logs = relationship("DeviceLog", back_populates="device")
    details = relationship("DeviceDetail", back_populates="device")

class DeviceLog(Base):
    __tablename__ = 'devices_logs'

    id = Column(Integer, primary_key=True, index=True)
    devices_id = Column(Integer, ForeignKey('devices.id'))
    power_value = Column(Float, nullable=False)
    log_at = Column(TIMESTAMP, nullable=False, default=datetime.utcnow)

    device = relationship("Device", back_populates="logs")

class DeviceDetail(Base):
    __tablename__ = 'devices_details'

    id = Column(Integer, primary_key=True, index=True)
    devices_id = Column(Integer, ForeignKey('devices.id'))
    channel_id = Column(Integer, nullable=False)
    channel_status = Column(Integer, nullable=False)
    update_at = Column(TIMESTAMP, nullable=False, default=datetime.utcnow)
    location = Column(String(255), nullable=True)

    device = relationship("Device", back_populates="details")

# สร้างตารางในฐานข้อมูล
Base.metadata.create_all(bind=engine)

app = FastAPI()

# Pydantic Models สำหรับการตรวจสอบข้อมูล
class DeviceCreate(BaseModel):
    device_name: str
    current_value: int
    device_status: bool
    firmware_version: str = None

class DeviceLogResponse(BaseModel):
    id: int
    devices_id: int
    power_value: float
    log_at: str

class DeviceDetailResponse(BaseModel):
    id: int
    devices_id: int
    channel_id: int
    channel_status: int
    update_at: str
    location: str

class DeviceResponse(DeviceCreate):
    id: int
    create_at: str

class DeviceWithLogsAndDetails(DeviceResponse):
    logs: list[DeviceLogResponse] = []
    details: list[DeviceDetailResponse] = []
    
class UserLogin(BaseModel):
    username: str
    password: str


class UserCreate(BaseModel):
    username: str
    password: str
    name: str
    
class UserResponse(BaseModel):
    id: int
    username: str
    name: str
    create_at: str

    
def get_password_hash(password: str):
    return pwd_context.hash(password)

def verify_password(plain_password: str, password: str):
    return pwd_context.verify(plain_password, password)

# Route สำหรับการดึงข้อมูลอุปกรณ์ทั้งหมด
@app.get("/devices/", response_model=list[DeviceResponse])
def get_devices(skip: int = 0, limit: int = 10):
    db = SessionLocal()
    devices = db.query(Device).offset(skip).limit(limit).all()
    db.close()
    
    return [
        {
            "id": device.id,
            "device_name": device.device_name,
            "current_value": device.current_value,
            "device_status": device.device_status,
            "firmware_version": device.firmware_version,
            "create_at": device.create_at.isoformat()
        } for device in devices
    ]

# Route สำหรับการดึงข้อมูลอุปกรณ์พร้อม Logs และ Details
@app.get("/devices/{device_id}", response_model=DeviceWithLogsAndDetails)
def get_device(device_id: int):
    db = SessionLocal()
    device = db.query(Device).filter(Device.id == device_id).first()
    
    if device is None:
        db.close()
        raise HTTPException(status_code=404, detail="Device not found")

    logs = [
        {
            "id": log.id,
            "devices_id": log.devices_id,
            "power_value": log.power_value,
            "log_at": log.log_at.isoformat()
        } for log in device.logs
    ]
    
    details = [
        {
            "id": detail.id,
            "devices_id": detail.devices_id,
            "channel_id": detail.channel_id,
            "channel_status": detail.channel_status,
            "update_at": detail.update_at.isoformat(),
            "location": detail.location
        } for detail in device.details
    ]

    return {
        "id": device.id,
        "device_name": device.device_name,
        "current_value": device.current_value,
        "device_status": device.device_status,
        "firmware_version": device.firmware_version,
        "create_at": device.create_at.isoformat(),
        "logs": logs,
        "details": details,
    }

# Route สำหรับการเพิ่มอุปกรณ์ใหม่
@app.post("/devices/", response_model=DeviceResponse)
def create_device(device: DeviceCreate):
    db = SessionLocal()
    new_device = Device(**device.dict(), create_at=datetime.utcnow())
    db.add(new_device)
    db.commit()
    db.refresh(new_device)
    db.close()

    return {
        "id": new_device.id,
        "device_name": new_device.device_name,
        "current_value": new_device.current_value,
        "device_status": new_device.device_status,
        "firmware_version": new_device.firmware_version,
        "create_at": new_device.create_at.isoformat()
    }

# Route สำหรับการอัปเดตอุปกรณ์
@app.put("/devices/{device_id}", response_model=DeviceResponse)
def update_device(device_id: int, device: DeviceCreate):
    db = SessionLocal()
    db_device = db.query(Device).filter(Device.id == device_id).first()
    
    if db_device is None:
        db.close()
        raise HTTPException(status_code=404, detail="Device not found")
    
    for key, value in device.dict().items():
        setattr(db_device, key, value)
    
    db.commit()
    db.refresh(db_device)
    db.close()

    return {
        "id": db_device.id,
        "device_name": db_device.device_name,
        "current_value": db_device.current_value,
        "device_status": db_device.device_status,
        "firmware_version": db_device.firmware_version,
        "create_at": db_device.create_at.isoformat()
    }

# Route สำหรับการลบอุปกรณ์
@app.delete("/devices/{device_id}")
def delete_device(device_id: int):
    db = SessionLocal()
    db_device = db.query(Device).filter(Device.id == device_id).first()
    
    if db_device is None:
        db.close()
        raise HTTPException(status_code=404, detail="Device not found")
    
    db.delete(db_device)
    db.commit()
    db.close()
    return {"detail": "Device deleted successfully"}

@app.post("/register/", response_model=UserResponse)
def register(user: UserCreate):
    db = SessionLocal()

    # Check if the username already exists
    db_user = db.query(User).filter(User.username == user.username).first()
    if db_user:
        db.close()
        raise HTTPException(status_code=400, detail="Username already registered")

    # Hash the password
    hashed_password = get_password_hash(user.password)
    new_user = User(username=user.username, password=hashed_password)

    # Create user details and assign a default devices_id if necessary
    user_detail = UserDetail(name=user.name, devices_id=None)  # or set to 0 if needed
    new_user.details = user_detail

    db.add(new_user)
    db.commit()
    db.refresh(new_user)
    db.close()

    return {
        "id": new_user.id,
        "username": new_user.username,
        "name": new_user.details.name,
        "create_at": new_user.create_at.isoformat(),
    }

@app.post("/login/")
def login(user: UserLogin):
    db = SessionLocal()
    db_user = db.query(User).filter(User.username == user.username).first()
    
    if not db_user or not verify_password(user.password, db_user.password):
        db.close()
        raise HTTPException(status_code=400, detail="Incorrect username or password")
    
    # If login is successful, return user details
    user_detail = db_user.details
    db.close()
    
    return {
        "detail": "Login successful",
        "user": {
            "id": db_user.id,
            "username": db_user.username,
            "name": user_detail.name if user_detail else None,
            "create_at": db_user.create_at.isoformat(),
        }
    }
