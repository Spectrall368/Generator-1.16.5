<#if w.hasElementsOfType("gui")>
if (${input$entity} instanceof PlayerEntity && ((PlayerEntity) ${input$entity}).openContainer instanceof ${JavaModName}Menus.MenuAccessor)
	((${JavaModName}Menus.MenuAccessor) ((PlayerEntity) ${input$entity}).openContainer).sendMenuStateUpdate((PlayerEntity) ${input$entity}, 0, "${field$textfield}", ${input$text}, true);
</#if>