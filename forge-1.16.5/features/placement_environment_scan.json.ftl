£boolean scan_env = false;
for(int i = 0; i < ${field$maxSteps} && !scan_env; i++) {
  placePos = placePos.<#if generator.map(field$direction, "directions") == "Direction.DOWN">down<#else>up</#if>();
  if(${input$condition})
    scan_env = true;
}
if(!scan_env)
  return false;^
