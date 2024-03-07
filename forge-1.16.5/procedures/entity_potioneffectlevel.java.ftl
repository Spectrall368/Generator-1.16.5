/*@int*/(${input$entity} instanceof LivingEntity && ((LivingEntity) ${input$entity}).isPotionActive(${generator.map(field$potion, "effects")}) ?
    ((LivingEntity) ${input$entity}).getActivePotionEffect(${generator.map(field$potion, "effects")}).getAmplifier() : 0)
