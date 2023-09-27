<#assign entity = generator.map(field$entity, "entities", 1)!"null">
(<#if entity != "null">world instanceof World ? new ${generator.map(field$entity, "entities", 0)}(${entity}, (World) world) : </#if>null)
