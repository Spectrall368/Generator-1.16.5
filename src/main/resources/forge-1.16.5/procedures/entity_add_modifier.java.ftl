<#assign attr = generator.map(field$attribute, "attributes")>
if (${input$entity} instanceof LivingEntity) {
	LivingEntity _entity = (LivingEntity) ${input$entity};
	AttributeModifier modifier = new AttributeModifier(UUID.fromString("${w.getUUID(field$name)}"), "${modid + ':' + field$name}", ${input$value}, AttributeModifier.Operation.${field$operation?replace("ADD_VALUE", "ADDITION")?replace("ADD_MULTIPLIED_BASE", "MULTIPLY_BASE")?replace("ADD_MULTIPLIED_TOTAL", "MULTIPLY_TOTAL")});
	<#if field$permanent == "FALSE">
	modifier.setSaved(false);
    </#if>
	if (!_entity.getAttribute(${attr}).hasModifier(modifier))
			_entity.getAttribute(${attr}).applyModifier(modifier);
}