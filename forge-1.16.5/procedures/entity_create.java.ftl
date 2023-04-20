<#assign entity = generator.map(field$entity, "entities", 1)!"null">
(<#if entity != "null">world instanceof World _world ? new ${generator.map(field$entity, "entities", 0)}(${entity}, _world) : </#if>null)
