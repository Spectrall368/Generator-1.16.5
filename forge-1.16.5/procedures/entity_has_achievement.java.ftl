(${input$entity} instanceof ServerPlayerEntity && ((ServerPlayerEntity) ${input$entity}).world instanceof ServerWorld && ((ServerPlayerEntity) ${input$entity}).getAdvancements()
        .getProgress(((ServerPlayerEntity) ${input$entity}).server.getAdvancementManager().getAdvancement(new ResourceLocation("${generator.map(field$achievement, "achievements")}"))).isDone())
