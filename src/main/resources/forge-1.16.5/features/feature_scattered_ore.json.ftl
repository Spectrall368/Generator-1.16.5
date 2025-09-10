<#assign targetPipePattern = r'\|([^|]+)\|'>
<#assign targetPipeMatches = input_list$target[0]?matches(targetPipePattern)>
<#assign extractedFromTarget = targetPipeMatches[0]?groups[1]>
<#assign cleanedTarget = input_list$target[0]?replace(targetPipePattern, '', 'r')>
new OreFeatureConfig(${cleanedTarget}, ${extractedFromTarget}, ${field$size})