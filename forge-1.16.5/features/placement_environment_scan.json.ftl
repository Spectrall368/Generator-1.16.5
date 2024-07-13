boolean scan_env_adv = false;
BlockPos env_pos = placePos;
for(i = 0; i < ${field$maxSteps} && ${input$searchCondition}; i++) {
  env_pos = env_pos.<#if generator.map(field$direction, "directions") == "Direction.DOWN">down<#else>up</#if>();
  if(${input$condition}) {
    scan_env_adv = true;
    break;
  }
}
if(!scan_env_adv)
  return false;
