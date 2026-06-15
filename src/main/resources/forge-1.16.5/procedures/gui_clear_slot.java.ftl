<@head>if (${input$entity} instanceof PlayerEntity && ((PlayerEntity) ${input$entity}).openContainer instanceof ${JavaModName}Menus.MenuAccessor) {</@head>
	((${JavaModName}Menus.MenuAccessor) ((PlayerEntity) ${input$entity}).openContainer).getSlots().get(${opt.toInt(input$slotid)}).putStack(ItemStack.EMPTY);
<@tail>
	((PlayerEntity) ${input$entity}).openContainer.detectAndSendChanges();
}</@tail>