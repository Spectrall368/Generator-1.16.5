<#-- @formatter:off -->
<#include "../mcitems_json.ftl">
{
    "type": "minecraft:smithing",
    "base": {
      ${mappedMCItemToItemObjectJSON(data.smithingInputStack)}
    },
    "addition": {
      ${mappedMCItemToItemObjectJSON(data.smithingInputAdditionStack)}
    },
    "result": {
      ${mappedMCItemToItemObjectJSON(data.smithingReturnStack)}
    }
}
<#-- @formatter:on -->