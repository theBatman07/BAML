from fastapi import FastAPI
from pydantic import BaseModel
from typing import List, Dict
from baml_client import b
from baml_client.types import Tool, Instruction, PlanExecute, PlanResult

from dotenv import load_dotenv
load_dotenv() 

app = FastAPI()

class Tool(BaseModel):
    name: str

# class ToolCall(BaseModel):
#     tool_name: str
#     args: Dict[str, any]

class PlannerRequest(BaseModel):
    instructions: str
    tools: List[str]

class PlannerResponse(BaseModel):
    plan: List[str]

class PlanExecuteRequest(BaseModel):
    steps: List[str]
    tools: List[str]

class PlanResult(BaseModel):
    result: str

@app.post("/plannar")
async def generate_plans(request: PlannerRequest) -> PlannerResponse:
    instruction = Instruction(description=request.instructions)
    tools = [Tool(name=tool) for tool in request.tools]

    response = b.GeneratePlans(instruction, tools)

    return PlannerResponse(plan=response.plans)

@app.post("/execute-plan")
async def plan_executer(request: PlanExecuteRequest) -> PlanResult:
    steps = [PlanExecute(steps=step) for step in request.steps]
    tools = [Tool(name=tool) for tool in request.tools]

    response = b.ExecutePlan(steps, tools)

    return PlanResult(result=response.result)
