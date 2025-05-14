client<llm> GPT4o {
    provider openai
    options {
        model "gpt-4o"
        api_key env.OPENAI_KEY
    }
}

class Instruction {
    description string
}

class Tool {
    name string
}

class ToolCall {
    tool_name string
}

class Response {
    plans string
}

class Steps {
    step string
}

class PlanResult {
    result string
}

function GeneratePlans(instruction: Instruction, tools: Tool[]) -> Response {
    client GPT4o
    prompt #"

        Below are the list of tools that are provided:
        
        {% for tool in tools %}
        {{ tool.name }}
        {% endfor %}
        
        You are a expert planner, that can take input in natural language, identify the tools prsent in the instruction: {{ instruction.description }},
        then after carefull analysis, provide the list of tool calls (STEPS) that can be taken

        {{ ctx.output_format }}
    
    "#
}

function Sum(a: int, b: int) -> string {
  client GPT4o
  prompt #"What is {{ a }} + {{ b }}?"#
}

function Subtract(a: int, b: int) -> string {
  client GPT4o
  prompt #"What is {{ a }} - {{ b }}?"#
}

function Multiply(a: int, b: int) -> string {
  client GPT4o
  prompt #"What is {{ a }} * {{ b }}?"#
}

function Divide(a: int, b: int) -> string {
  client GPT4o
  prompt #"What is {{ a }} / {{ b }}?"#
}


function ExecutePlan(steps: Steps[]) -> PlanResult {
    client GPT4o

    prompt #"
        You are a function orchestrator. Given a list of step instructions, identify whether to use Sum, Subtract, Multiply or Divide (only call divide if b is greater than 0 otherwise return error: cannot divide by zero).

        Call the appropriate function using the input values extracted from the step.
    

        {% for st in steps %}
            {{ st.step }}
        {% endfor %}

        {{ ctx.output_format }}
    "#
}