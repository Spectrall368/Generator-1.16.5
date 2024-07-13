boolean scan_env = false;
for(i = 0; i < ${field$maxSteps}; i++) {
  placePos = placePos.<#if generator.map(field$direction, "directions") == "Direction.DOWN">down<#else>up</#if>();
  if(${input$condition}) {
    scan_env = true;
    break;
  }
}
if(!scan_env)
  return false;
