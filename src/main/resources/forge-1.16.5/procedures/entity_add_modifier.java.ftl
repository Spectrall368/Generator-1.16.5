<#assign attr = generator.map(field$attribute, "attributes")>
if (${input$entity} instanceof LivingEntity) {
	LivingEntity _entity = (LivingEntity) ${input$entity};
	AttributeModifier modifier = new AttributeModifier(UUID.fromString("${w.getUUID(field$name)}"), "${modid + ':' + field$name}", ${input$value}, AttributeModifier.Operation.${field$operation?replace("ADD_VALUE", "ADDITION")?replace("ADD_MULTIPLIED_BASE", "MULTIPLY_BASE")?replace("ADD_MULTIPLIED_TOTAL", "MULTIPLY_TOTAL")});
	if (!_entity.getAttribute(${attr}).hasModifier(modifier)) {
		<#if field$permanent == "TRUE">
			_entity.getAttribute(${attr}).applyPersistentModifier(modifier);
		<#else>
			_entity.getAttribute(${attr}).applyNonPersistentModifier(modifier);
		</#if>
	}
}