(${input$entity} instanceof LivingEntity && ((LivingEntity) ${input$entity}).getAttributeManager().hasAttributeInstance(${generator.map(field$attribute, "attributes")})
? ((LivingEntity) ${input$entity}).getAttribute(${generator.map(field$attribute, "attributes")}).getValue() : 0)
