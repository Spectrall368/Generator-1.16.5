<#if field$damagesource?has_content>
${input$entity}.attackEntityFrom(${generator.map(field$damagesource, "damagesources")}, ${opt.toFloat(input$amount)});
<#else>
${input$entity}.attackEntityFrom(DamageSource.GENERIC, ${opt.toFloat(input$amount)});
</#if>
