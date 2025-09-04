<#-- @formatter:off -->
<#if data.itemTexture?has_content>
{
  "parent": "item/generated",
  "textures": {
    "layer0": "${data.itemTexture.format("%s:item/%s")}"
  }
}
<#else>
{
  "parent": "item/generated",
  "textures": {
    "layer0": "${data.texture.format("%s:block/%s")}"
  }
}
</#if>
<#-- @formatter:on -->
