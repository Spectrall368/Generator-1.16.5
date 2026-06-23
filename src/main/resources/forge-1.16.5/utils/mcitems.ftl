<#include "mcitems_json.ftl">
<#t>
<#function mappedBlockToBlockStateCode mappedBlock>
    <#if mappedBlock?trim?starts_with("/*@BlockState*/")>
        <#return mappedBlock?replace("/*@BlockState*/","")>
    <#elseif mappedBlock?contains("/*@?*/")>
        <#assign outputs = mappedBlock?keep_after("/*@?*/")?keep_before_last(")")>
        <#return mappedBlock?keep_before("/*@?*/") + "?" + mappedBlockToBlockStateCode(outputs?keep_before("/*@:*/"))
            + ":" + mappedBlockToBlockStateCode(outputs?keep_after("/*@:*/")) + ")">
    <#else>
        <#return mappedBlockToBlock(mappedBlock) + ".getDefaultState()">
    </#if>
</#function>

<#function mappedBlockToBlock mappedBlock>
    <#if mappedBlock?trim?starts_with("/*@BlockState*/")>
        <#return mappedBlock?replace("/*@BlockState*/","") + ".getBlock()">
    <#elseif mappedBlock?contains("/*@?*/")>
        <#assign outputs = mappedBlock?keep_after("/*@?*/")?keep_before_last(")")>
        <#return mappedBlock?keep_before("/*@?*/") + "?" + mappedBlockToBlock(outputs?keep_before("/*@:*/"))
            + ":" + mappedBlockToBlock(outputs?keep_after("/*@:*/")) + ")">
    <#elseif mappedBlock?starts_with("CUSTOM:")>
        <#return mappedElementToRegistryEntry(mappedBlock)>
    <#else>
        <#return mappedBlock>
    </#if>
</#function>

<#function mappedMCItemToItemStackCode mappedBlock amount=1>
    <#if mappedBlock?trim?starts_with("/*@ItemStack*/")>
        <#return mappedBlock?replace("/*@ItemStack*/", "")>
    <#elseif mappedBlock?contains("/*@?*/")>
        <#assign outputs = mappedBlock?keep_after("/*@?*/")?keep_before_last(")")>
        <#return mappedBlock?keep_before("/*@?*/") + "?" + mappedMCItemToItemStackCode(outputs?keep_before("/*@:*/"), amount)
            + ":" + mappedMCItemToItemStackCode(outputs?keep_after("/*@:*/"), amount) + ")">
    <#elseif mappedBlock?starts_with("CUSTOM:")>
        <#return toItemStack(mappedElementToRegistryEntry(mappedBlock), amount)>
    <#else>
        <#return toItemStack(mappedBlock, amount)>
    </#if>
</#function>

<#function toItemStack item amount>
    <#if amount == 1>
        <#return "new ItemStack(" + item + ")">
    <#else>
        <#return "new ItemStack(" + item + "," + (amount == amount?floor)?then(amount + ")","(int)(" + amount + "))")>
    </#if>
</#function>

<#function mappedMCItemToItem mappedBlock>
    <#if mappedBlock?trim?starts_with("/*@ItemStack*/")>
        <#return mappedBlock?replace("/*@ItemStack*/", "") + ".getItem()">
    <#elseif mappedBlock?contains("/*@?*/")>
        <#assign outputs = mappedBlock?keep_after("/*@?*/")?keep_before_last(")")>
        <#return mappedBlock?keep_before("/*@?*/") + "?" + mappedMCItemToItem(outputs?keep_before("/*@:*/"))
            + ":" + mappedMCItemToItem(outputs?keep_after("/*@:*/")) + ")">
    <#elseif mappedBlock?starts_with("CUSTOM:")>
        <#return mappedElementToRegistryEntry(mappedBlock) + generator.isBlock(mappedBlock)?then(".asItem()", "")>
    <#else>
        <#return mappedBlock + mappedBlock?contains("Blocks.")?then(".asItem()","")>
    </#if>
</#function>

<#function mappedMCItemToIngredient mappedBlock>
    <#if mappedBlock.getUnmappedValue().startsWith("TAG:")>
        <#return "Ingredient.fromTag(ItemTags.createOptional(new ResourceLocation(\"" + mappedBlock.getUnmappedValue().replace("TAG:", "").replace("mod:", modid + ":") + "\")))">
    <#elseif mappedBlock.getMappedValue(1).startsWith("#")>
        <#return "Ingredient.fromTag(ItemTags.createOptional(new ResourceLocation(\"" + mappedBlock.getMappedValue(1).replace("#", "") + "\")))">
    <#else>
        <#return "Ingredient.fromStacks(" + mappedMCItemToItemStackCode(mappedBlock, 1) + ")">
    </#if>
</#function>

<#function mappedMCItemsToIngredient mappedBlocks=[]>
    <#if !mappedBlocks??>
        <#return "Ingredient.EMPTY">
    <#elseif mappedBlocks?size == 1>
        <#return mappedMCItemToIngredient(mappedBlocks?first)>
    <#else>
        <#assign itemsOnly = true>

        <#list mappedBlocks as mappedBlock>
            <#if mappedBlock.getUnmappedValue().startsWith("TAG:") || mappedBlock.getMappedValue(1).startsWith("#")>
                <#assign itemsOnly = false>
                <#break>
            </#if>
        </#list>

        <#if itemsOnly>
            <#assign retval = "Ingredient.fromStacks(">
            <#list mappedBlocks as mappedBlock>
                <#assign retval += mappedMCItemToItemStackCode(mappedBlock, 1)>

                <#if mappedBlock?has_next>
                    <#assign retval += ",">
                </#if>
            </#list>
            <#return retval + ")">
        <#else>
            <#assign retval = "Ingredient.merge(Arrays.asList(">
            <#list mappedBlocks as mappedBlock>
                <#assign retval += mappedMCItemToIngredient(mappedBlock)>

                <#if mappedBlock?has_next>
                    <#assign retval += ",">
                </#if>
            </#list>
            <#return retval + "))">
        </#if>
    </#if>
</#function>

<#function containsAnyOfBlocks elements blockToCheck>
    <#assign blocks = []>
    <#assign tags = []>
    <#assign retval = "">

    <#list elements as block>
        <#if block.getUnmappedValue().startsWith("TAG:")>
            <#assign tags += [block.getUnmappedValue().replace("TAG:", "").replace("mod:", modid + ":")]>
        <#elseif block.getMappedValue(1).startsWith("#")>
            <#assign tags += [block.getMappedValue(1).replace("#", "")]>
        <#else>
            <#assign blocks += [mappedBlockToBlock(block)]>
        </#if>
    </#list>

    <#if !blocks?has_content && !tags?has_content>
        <#return "false">
    <#elseif blocks?has_content>
    	<#assign retval += "Arrays.asList(">
        <#list blocks as block>
        	<#assign retval += block>
			<#if block?has_next><#assign retval += ","></#if>
        </#list>
        <#assign retval += ").contains("+ blockToCheck + ".getBlock())">

        <#if tags?has_content>
        	<#assign retval += "||">
        </#if>
    </#if>

    <#if tags?has_content>
    	<#assign retval += "Stream.of(">
        <#list tags as tag>
        	<#assign retval += "BlockTags.createOptional(new ResourceLocation(\"" + tag + "\"))">
            <#if tag?has_next><#assign retval += ","></#if>
        </#list>
        <#assign retval += ").anyMatch(" + blockToCheck + "::isIn)">
    </#if>

    <#return retval>
</#function>

<#function mappedElementToRegistryEntry mappedElement>
    <#return JavaModName + generator.isBlock(mappedElement)?then("Blocks", "Items") + "."
    + handleExtension(mappedElement, generator.getRegistryNameFromFullName(mappedElement))?upper_case + ".get()">
</#function>

<#function mappedBlockToBlockStateProvider mappedBlock>
    <#if mappedBlock?starts_with("/*@BlockStateProvider*/")>
        <#return mappedBlock?replace("/*@BlockStateProvider*/", "")>
    <#else>
        <#return "new SimpleBlockStateProvider(" + mappedBlockToBlockStateCode(mappedBlock) + ")">
    </#if>
</#function>

<#function toFeatureState block>
    <#if block?contains("FeatureUtils") && block?contains(".getDefaultState()")>
        <#local idx = block?last_index_of(".getDefaultState()")>
        <#return block?substring(0, idx) + block?substring(idx + ".getDefaultState()"?length)>
    <#else>
        <#return block>
    </#if>
</#function>

<#function toStateProvidertoFeatureState block>
    <#return toFeatureState(mappedBlockToBlockStateProvider(block))>
</#function>

<#function toStatetoFeatureState block>
    <#return toFeatureState(mappedBlockToBlockStateCode(block))>
</#function>