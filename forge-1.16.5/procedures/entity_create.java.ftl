<#assign entity = generator.map(field$entity, "entities", 1)!"null">
(<#if entity != "null">world instanceof World world ? new ${generator.map(field$entity, "entities", 0)}(${entity}, world) : </#if>null)
