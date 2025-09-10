<#if w.hasElementsOfType("feature")>
public net.minecraft.world.gen.feature.NoExposedOreFeature <init>(Lcom/mojang/serialization/Codec;)V #constructor
public-f net.minecraft.world.gen.feature.TreeFeature func_241855_a(Lnet/minecraft/world/ISeedReader;Lnet/minecraft/world/gen/ChunkGenerator;Ljava/util/Random;Lnet/minecraft/util/math/BlockPos;Lnet/minecraft/world/gen/feature/BaseTreeFeatureConfig;)Z # place
</#if>

<#if w.getGElementsOfType('gamerule')?filter(e -> e.type.equals('Number'))?size != 0>
public net.minecraft.world.GameRules$IntegerValue func_223559_b(I)Lnet/minecraft/world/GameRules$RuleType; #create
</#if>

<#if w.getGElementsOfType('gamerule')?filter(e -> e.type.equals('Logic'))?size != 0>
public net.minecraft.world.GameRules$BooleanValue func_223568_b(Z)Lnet/minecraft/world/GameRules$RuleType; #create
</#if>

<#if w.hasElementsOfType("villagerprofession")>
public net.minecraft.village.PointOfInterestType func_221052_a(Lnet/minecraft/village/PointOfInterestType;)Lnet/minecraft/village/PointOfInterestType; #registerBlockStates
</#if>

<#if w.hasElementsOfType("structure")>
public-f net.minecraft.world.gen.feature.structure.Structure field_236384_t_ #LAND_TRANSFORMING_STRUCTURES
public-f net.minecraft.world.gen.settings.DimensionStructuresSettings field_236191_b_ #DEFAULT_STRUCTURE_CONFIGS
public-f net.minecraft.world.gen.FlatGenerationSettings field_202247_j #STRUCTURES
public-f net.minecraft.world.gen.settings.DimensionStructuresSettings field_236193_d_ #structures
</#if>

# Start of user code block custom ATs
# End of user code block custom ATs