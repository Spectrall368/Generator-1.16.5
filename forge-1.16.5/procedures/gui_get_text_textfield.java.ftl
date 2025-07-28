<#if w.hasElementsOfType("gui")>
((${input$entity} instanceof PlayerEntity && ((PlayerEntity) ${input$entity}).openContainer instanceof ${JavaModName}Menus.MenuAccessor) ? ((${JavaModName}Menus.MenuAccessor) ((PlayerEntity) ${input$entity}).openContainer).getMenuState(0, "${field$textfield}", "") : "")
<#else>""</#if>