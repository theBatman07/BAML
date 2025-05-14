from fastapi import FastAPI
from pydantic import BaseModel
from typing import List, Dict

app = FastAPI()

class Tool(BaseModel):
    name: str
    description: str 
    parameters: Dict[str, str]

class ToolCall(BaseModel):
    tool_name: str
    args: Dict[str, any]

class PlannerRequest(BaseModel):
    instructions: str
    tools: List[str]

class PlannerResponse(BaseModel):
    plan: List[str]


@app.post("/plannar")
async def generate_plans(request: PlannerRequest) -> PlannerResponse:
    pass