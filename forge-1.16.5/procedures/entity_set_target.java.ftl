if (${input$entity} instanceof MobEntity && ${input$sourceentity} instanceof LivingEntity)
	((MobEntity) ${input$entity}).setAttackTarget((LivingEntity) ${input$sourceentity});
