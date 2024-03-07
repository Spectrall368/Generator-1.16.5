(${input$entity} instanceof LivingEntity ? ((LivingEntity) ${input$entity}).isPotionActive(${generator.map(field$potion, "effects")}) : false)
