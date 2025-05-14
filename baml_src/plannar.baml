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
    plans string[]
}

class PlanExecute {
    steps string
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

        Your answer for each step should start as the following,
        Step i: {the tool calls to be used}

        where i is Natural number (step number)

        {{ ctx.output_format }}
    
    "#
}

function ExecutePlan(steps: PlanExecute[], tools: Tool[]) -> PlanResult {
    client GPT4o

    prompt #"
        You are a step executor. Given a list of steps, execute them one by one and provide the final result.
        Apply the appropriate logic according to the step

        You have been provided with a set of tools, use the appropriate tool at each step

        {% for tool in tools %}
        {{ tool.name }}
        {% endfor %}


        {% for st in steps %}
            {{ st.steps }}
        {% endfor %}

        Answer in JSON using this schema:
        {
            result: string
        }
    "#
}