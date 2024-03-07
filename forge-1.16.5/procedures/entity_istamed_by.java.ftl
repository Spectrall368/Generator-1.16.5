(${input$entity} instanceof TamableEntity && ${input$tamedBy} instanceof LivingEntity
        ? ((TameableEntity) ${input$entity}).isOwner((LivingEntity) ${input$tamedBy}):false)
