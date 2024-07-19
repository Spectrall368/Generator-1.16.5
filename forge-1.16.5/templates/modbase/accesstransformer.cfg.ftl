<#if w.getGElementsOfType('gamerule')?filter(e -> e.type.equals('Number'))?size != 0>
public net.minecraft.world.GameRules$IntegerValue func_223559_b(I)Lnet/minecraft/world/GameRules$RuleType; #create
</#if>
<#if w.getGElementsOfType('gamerule')?filter(e -> e.type.equals('Logic'))?size != 0>
public net.minecraft.world.GameRules$BooleanValue func_223568_b(Z)Lnet/minecraft/world/GameRules$RuleType; #create
</#if>
<#if w.hasElementsOfType("villagerprofession")>
public net.minecraft.village.PointOfInterestType func_221052_a(Lnet/minecraft/village/PointOfInterestType;)Lnet/minecraft/village/PointOfInterestType; #registerBlockStates
</#if>
