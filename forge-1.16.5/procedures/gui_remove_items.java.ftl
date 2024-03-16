if(${input$entity} instanceof PlayerEntity && ((PlayerEntity) ${input$entity}).openContainer instanceof Supplier && ((Supplier) ((PlayerEntity) ${input$entity}).openContainer).get() instanceof Map) {
	((Slot) ((Map) ((Supplier) ((PlayerEntity) ${input$entity}).openContainer).get()).get(${opt.toInt(input$slotid)})).decrStackSize(${opt.toInt(input$amount)});
	((PlayerEntity) ${input$entity}).openContainer.detectAndSendChanges();
}
