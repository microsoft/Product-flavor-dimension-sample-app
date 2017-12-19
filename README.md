# Product flavor dimension sample app
### Abstract
Project is meant to showcase the way to add new product dimension in a completely overlayering free way.

### Supported scenario so far
1.	Create flavor dimension values.
2.	Create a product dimension group that includes the flavor dimension.
3.	Create a flavor dimension group with few values.
4.	Create a product master and assign earlier created product dimension group.
5.	Either choose predefined flavor dimension group or edit master product dimensions and choose few flavors.
6.	Create variants for the product.
7.	Release the product/variants.
8.	Edit released product: adjust standard and alternate flavor dimension.
9.	Adjust quantity on hand for the released variants.
10. Create purchase order, confirm and receive it.
11. Create sales order, ship it.

### Getting started
- Copy content of the repo into RainMain folder
- Edit \AxPackage\ChocolateyPackages\dirs file and add following lines:

			ProductFlavor{amd64,app} \
			ProductFlavorIntegration{amd64,app} \
			ProductFlavorTests{amd64,app} \
			
- Edit \AxPackage\ChocolateyPackages\MetaPackagesApplication\PackageTable.csv file and add following lines:

			productflavor,,,R,"R,C,D",,,T
			productflavorintegration,,,R,"R,C,D",,,T
			productflavortests,,,R,"R,C,D",,,T
			
- Enable InventDimension1 and EcoResProductFlavor configuration keys with the following x++ script: 

	        ConfigurationKeySet set = new ConfigurationKeySet();
	        set.loadSystemSetup();
	        set.enabled(configurationKeyNum(InventDimension1),  true);
	        set.enabled(configurationKeyNum(EcoResProductFlavor),  true);
	        SysDictConfigurationKey::save(set.pack());
	        SysSecurity::reload(true, true, true);
			
- Rebuild flavor models
	

### Extensibility guideline
#### NB: 

- It is often easier to copy elements of another product dimension that have same purpose (e.g. tables or forms to work with dimension values or groups, views, security privileges, menu items, etc).
- Names for newly created objects can be easily changed and listed here to ease navigation in the code.
- Extending an existing form is typically done in order to add new dimension related data sources or extra field
- Extending form classes is typically done in order to add various metadata info about new dimension so that it is taken into account during the processing of a user input by the form.
- Extending an existing table typically involves adding new fields, relations, changing field groups and indexes.

#### Steps:

##### General preparation

 - Create a configuration key that will correspond to the new dimension and use every time you create new table, view, form extension, EDT or any other element that can be marked with a config key.
 - Follow procedure explained in the [blog post](https://blogs.msdn.microsoft.com/mfp/2017/08/10/extensible-inventory-dimensions/) by Michael Fruergaard Pontoppidan in order to extend the product dimension class hierarchy.
 - Provide the way to store and manage dimension values by adding a table, form, display menu item and corresponding security privileges.
 - Create labels file in order to store new dimension text resources.
 
##### Defining a variant with new dimension

 - Extend EcoResProductMasterDimension form in order to add capability of defining available new dimensions for a product master.
 - Provide the way to add new dimensions to product master dimensions setup:
	 - extend EcoResProductMasterDimension form, its corresponding class and table;
	 - add new EcoResProductMaster[name] table to store the configured values;
 - Extend variant details forms in order to let user manage variants that have new dimension:
	 - extend EcoResProductVariants form and form class;
	 - same with EcoResProductVariantsPerCompany;
 - Provide the possibility to create dimension groups with predefined values by creating a set of objects:
	 - tables Retail[name]GroupTable, Retail[name]GroupTrans and Retail[name]GroupTransTranslation to store dimension group header, lines and translations respectively;
	 - form Retail[name]GroupTable in order to manage dimension groups;
	 - display menu item Retail[name]GroupTable and security privileges Retail[name]GroupsMaintain and Retail[name]GroupsView, they must be added to security duty extensions according to the desired accessibility level;
 - Extend product details form, its extended version and its form classes in order to let user ability to specify new dimension related properties.

##### Releasing a variant

 - Extend release relevant forms (at least EcoResProductRelease and EcoResProductReleaseSessions) to show a user new dimension values for variants being released.

##### Adjusting quantity

- Extend InventProductDimensionLookup form class in order to support new dimension while selecting a variant.

##### Navigation

 - Extend ProductInformationManagement menu and add newly created diplay menu items (for dimension groups and dimension values forms).


# Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit https://cla.microsoft.com.

When you submit a pull request, a CLA-bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., label, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.
