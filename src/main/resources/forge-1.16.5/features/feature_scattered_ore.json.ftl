<#local targetPipePattern = r'\|([^|]+)\|'>
<#local targetPipeMatches = input_list$target[0]?matches(targetPipePattern)>
<#local extractedFromTarget = targetPipeMatches[0]?groups[1]>
<#local cleanedTarget = input_list$target[0]?replace(targetPipePattern, '', 'r')>
new OreFeatureConfig(${cleanedString}, ${extractedFromTarget}, ${field$size})