£boolean scan_env_adv = false;
for(int i = 0; i < ${field$maxSteps} && !scan_env && ${input$searchCondition}; i++) {
  placePos = placePos.<#if generator.map(field$direction, "directions") == "Direction.DOWN">down<#else>up</#if>();
  if(${input$condition})
    scan_env_adv = true;
}
if(!scan_env_adv)
  return false;^
