<#if input$sourceentity == "null">
if (${input$entity} instanceof MobEntity) ((MobEntity) ${input$entity}).setAttackTarget(null);
<#else>
if (${input$entity} instanceof MobEntity && ${input$sourceentity} instanceof LivingEntity) ((MobEntity) ${input$entity}).setAttackTarget((LivingEntity) ${input$sourceentity});
</#if>