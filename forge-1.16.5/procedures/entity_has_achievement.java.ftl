(((${input$entity} instanceof ServerPlayerEntity)&&(${input$entity}.world instanceof ServerWorld))&&((ServerPlayerEntity)${input$entity}).getAdvancements()
        .getProgress(((MinecraftServer)((ServerPlayerEntity)${input$entity}).server).getAdvancementManager().getAdvancement(new ResourceLocation("${generator.map(field$achievement, "achievements")}"))).isDone())
