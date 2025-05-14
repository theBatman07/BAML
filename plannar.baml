client<llm> GPT4o {
    provider openai
    options {
        model "gpt-4o"
        api_key env.OPENAI_KEY
    }
}

class Tool {
    name string
}

class ToolCall {
    tool_name string
    args map<string, any>
}

class Response {
    plans string
}

function GeneratePlans(instruction: string, tools: Tool[]) -> Response {
    client GPT4o
    prompt #"

        Below are the list of tools that are provided:
        
        {% for tool in tools %}
        {{ tool.name }}
        {% endfor %}
        
        You are a expert planner, that can take input in natural language, identify the tools prsent in the instruction: {{ instruction }},
        then after carefull analysis, provide the list of tool calls (STEPS) that can be taken

        {{ ctx.output_format }}
    
    "#
}