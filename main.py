from fastapi import FastAPI
from pydantic import BaseModel
from typing import List, Dict
from baml_client import b
from baml_client.types import Tool, Instruction

from dotenv import load_dotenv
load_dotenv() 

app = FastAPI()

class Tool(BaseModel):
    name: str
    description: str 
    parameters: Dict[str, str]

# class ToolCall(BaseModel):
#     tool_name: str
#     args: Dict[str, any]

class PlannerRequest(BaseModel):
    instructions: str
    tools: List[str]

class PlannerResponse(BaseModel):
    plan: List[str]


@app.post("/plannar")
async def generate_plans(request: PlannerRequest) -> PlannerResponse:
    instruction = Instruction(description=request.instruction)
    tools = [Tool(name=tool) for tool in request.tools]

    response = await b.GeneratePlans(instruction, tools)

    return PlannerResponse(plan=response.plans)