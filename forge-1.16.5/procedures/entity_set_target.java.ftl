<#if input$sourceentity == "null">
if (${input$entity} instanceof MobEntity) ((MobEntity) ${input$entity}).setTarget(null);
<#else>
if (${input$entity} instanceof MobEntity && ${input$sourceentity} instanceof LivingEntity) ((MobEntity) ${input$entity}).setTarget((LivingEntity) ${input$sourceentity});
</#if>