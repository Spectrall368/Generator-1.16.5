((${input$entity} instanceof ServerPlayerEntity && !((ServerPlayerEntity) ${input$entity}).world.isRemote()) ?
((((ServerPlayerEntity) ${input$entity}).func_241141_L_().equals(((ServerPlayerEntity) ${input$entity}).world.getDimensionKey()) && ((ServerPlayerEntity) ${input$entity}).func_241140_K_() != null) ?
((ServerPlayerEntity) ${input$entity}).func_241140_K_().getX() : ((ServerPlayerEntity) ${input$entity}).world.getWorldInfo().getSpawnY()) : 0)
