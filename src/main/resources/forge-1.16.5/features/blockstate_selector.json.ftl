<#include "mcitems.ftl">
<#assign blockT = mappedBlockToBlock(w.itemBlock(field$block))>
<#if field_list$property?size != 0>
    <#assign state = blockT + ".getDefaultState()" >
    <#list 0..field_list$property?size-1 as i>
        <#assign valueType = field_list$value[i]>
        <#if (valueType != "true" && valueType != "false") && (!valueType?matches("^-?\\d+$"))>
            <#assign valueType = "\"" + field_list$value[i] + "\"" >
        </#if>
        <#assign state = JavaModName + "FeatureUtils.addProperty(" + state + ", \"" + field_list$property[i] + "\", " + valueType + ")" >
    </#list>
    ${state}
<#else>
    ${blockT}
</#if>