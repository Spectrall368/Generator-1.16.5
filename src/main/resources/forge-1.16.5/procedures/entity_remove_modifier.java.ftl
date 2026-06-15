if (${input$entity} instanceof LivingEntity) {
	((LivingEntity) ${input$entity}).getAttribute(${generator.map(field$attribute, "attributes")}).removeModifier(UUID.fromString("${w.getUUID(field$name)}"));
}