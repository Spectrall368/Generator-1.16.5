boolean scan_env = false;
BlockPos env_pos = placePos;
for(i = 0; i < ${field$maxSteps}; i++) {
  env_pos = env_pos.<#if generator.map(field$direction, "directions") == "Direction.DOWN">down<#else>up</#if>();
  if(${input$condition?replace("placePos", "env_pos")}) {
    scan_env = true;
    break;
  }
}
if(!scan_env)
  return false;
