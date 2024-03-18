import "@typespec/rest";
import "@typespec/http";
import "@typespec/openapi";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Rest;
using TypeSpec.Http;
using TypeSpec.OpenAPI;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;

#suppress "@azure-tools/typespec-azure-resource-manager/missing-operations-endpoint"
namespace Microsoft.Workloads;

/**
 * Defines the provisioning states.
 */
enum ProvisioningState {
  /** The provisioning state Succeeded. */
  Succeeded,

  /** The provisioning state Updating. */
  Updating,

  /** The provisioning state Failed. */
  Failed,

  /** The provisioning state Creating. */
  Creating,

  /** The provisioning state Cancelled. */
  Canceled,

  /** The provisioning state Accepted. */
  Accepted,

  /** The provisioning state Deleting. */
  Deleting,

  /** The provisioning state Unknown. */
  Unknown,
}

/**
 * The Environment; PRD, QA, DEV, etc to which SAP system belongs to. Select from the list of available dropdown values.
 */
enum SapInstanceEnvironment {
  /** The type of Sap Instance Environment- Production. */
  Production,

  /** The type of Sap Instance Environment- PreProduction. */
  PreProduction,

  /** The type of Sap Instance Environment- Test. */
  Test,

  /** The type of Sap Instance Environment- QualityAssurance. */
  QualityAssurance,

  /** The type of Sap Instance Environment- Development. */
  Development,

  /** The type of Sap Instance Environment- Sandbox. */
  Sandbox,

  /** The type of Sap Instance Environment- DisasterRecovery. */
  DisasterRecovery,

  /** The type of Sap Instance Environment- Training. */
  Training,
}

/**
 * The SAP instance type running on this machine, e.g., App, ASCS, DB, etc. Select from the list of available dropdown values. Only single server and distributed architectures are supported.
 */
enum SapInstanceType {
  /** The type of Sap Instance- ASCS. */
  ASCS,

  /** The type of Sap Instance- DB. */
  DB,

  /** The type of Sap Instance- APP. */
  APP,

  /** The type of Sap Instance- SCS. */
  SCS,

  /** The type of Sap Instance- WEBDISP. */
  WEBDISP,
}

/**
 * This is Operating System on which the host server is running.
 */
enum OperatingSystem {
  /** The type of Operating system- IBMAIX. */
  IBMAIX,

  /** The type of Operating system- RedHat. */
  RedHat,

  /** The type of Operating system- SUSE. */
  SUSE,

  /** The type of Operating system- Solaris. */
  Solaris,

  /** The type of Operating system- Unix. */
  Unix,

  /** The type of Operating system- WindowsServer. */
  WindowsServer,
}

/**
 * Select the database if this is a database server. Leave blank or add Not Applicable for all other instances except the Database Instance.
 */
enum DatabaseType {
  /** The type of Database- Adabas. */
  Adabas,

  /** The type of Database- Oracle. */
  Oracle,

  /** The type of Database- SAPMaxDB. */
  SAPMaxDB,

  /** The type of Database- Db2. */
  Db2,

  /** The type of Database- SAPASE. */
  SAPASE,

  /** The type of Database- SQLServer. */
  SQLServer,

  /** The type of Database- Informix. */
  Informix,

  /** The type of Database- SAPDB. */
  SAPDB,

  /** The type of Database- HANA. */
  HANA,
}

/**
 * The data source for this resource.
 */
enum DataSource {
  /** The type of DataSource- Excel. */
  Excel,

  /** The type of DataSource- Native. */
  Native,
}

/**
 * Defines the SAP Migration discovery site resource properties.
 */
#suppress "@azure-tools/typespec-azure-core/casing-style" "SAP is a product."
model SAPDiscoverySiteProperties {
  /**
   * The master site ID from Azure Migrate.
   */
  masterSiteId?: string;

  /**
   * The migrate project ID from Azure Migrate.
   */
  migrateProjectId?: string;

  /**
   * Defines the provisioning states.
   */
  @visibility("read")
  provisioningState?: ProvisioningState;

  /**
   * Indicates any errors on the SAP Migration discovery site resource.
   */
  @visibility("read")
  errors?: SAPMigrateError;
}

/**
 * An error response from the SAP migrate resources.
 */
#suppress "@azure-tools/typespec-azure-core/casing-style" "SAP is a product."
model SAPMigrateError {
  /**
   * The SAP Discovery site resource error body.
   */
  @extension("x-ms-client-flatten", true)
  properties?: ErrorDefinition;
}

/**
 * Error definition.
 */
model ErrorDefinition {
  /**
   * Service specific error code which serves as the substatus for the HTTP error code.
   */
  @visibility("read")
  code?: string;

  /**
   * Description of the error.
   */
  @visibility("read")
  message?: string;

  /**
   * Description of the recommendation.
   */
  @visibility("read")
  recommendation?: string;

  /**
   * Internal error details.
   */
  @visibility("read")
  details?: ErrorDefinition[];
}

/**
 * The extended location definition.
 */
model ExtendedLocation {
  /**
   * The extended location type.
   */
  type: string;

  /**
   * The extended location name.
   */
  name: string;
}

/**
 * Defines the SAP Instance properties.
 */
#suppress "@azure-tools/typespec-azure-core/casing-style" "SAP is a product."
model SAPInstanceProperties {
  /**
   * This is the SID of SAP System. Keeping this not equal to ID as different landscapes can have repeated System SID IDs.
   */
  @visibility("read")
  systemSid?: string;

  /**
   * The Environment; PRD, QA, DEV, etc to which SAP system belongs to. Select from the list of available dropdown values.
   */
  @visibility("read")
  environment?: SapInstanceEnvironment;

  /**
   * This is the SID of the production system in a landscape.  An SAP system could itself be a production SID or a part of a landscape with a different Production SID. This field can be used to relate non-prod SIDs, other components, SID (WEBDISP) to the prod SID. Enter the value of Production SID.
   */
  @visibility("read")
  landscapeSid?: string;

  /**
   * Enter a business function/department identifier to group multiple SIDs.
   */
  @visibility("read")
  application?: string;

  /**
   * Defines the provisioning states.
   */
  @visibility("read")
  provisioningState?: ProvisioningState;

  /**
   * Defines the errors related to SAP Instance resource.
   */
  @visibility("read")
  errors?: SAPMigrateError;
}

/**
 * Defines the SAP Instance properties.
 */
model ServerInstanceProperties {
  /**
   * This is the Virtual Machine Name of the SAP system. Add all the virtual machines attached to an SAP system which you wish to migrate to Azure. Keeping this not equal to ID as for single tier all InstanceTypes would be on same server, leading to multiple resources with same servername.
   */
  @visibility("read")
  serverName?: string;

  /**
   * Defines the type SAP instance on this server instance.
   */
  @visibility("read")
  sapInstanceType?: SapInstanceType;

  /**
   * This is the Instance SID for ASCS/AP/DB instance.  An SAP system with HANA database for example could have a different SID for database Instance than that of ASCS instance.
   */
  @visibility("read")
  instanceSid?: string;

  /**
   * This is the SAP Application Component; e.g. SAP S/4HANA 2022, SAP ERP ENHANCE PACKAGE.
   */
  @visibility("read")
  sapProduct?: string;

  /**
   * Provide the product version of the SAP product.
   */
  @visibility("read")
  sapProductVersion?: string;

  /**
   * This is Operating System on which the host server is running.
   */
  @visibility("read")
  operatingSystem?: OperatingSystem;

  /**
   * Configuration data for this server instance.
   */
  @visibility("read")
  configurationData?: ConfigurationData;

  /**
   * Configuration data for this server instance.
   */
  @visibility("read")
  performanceData?: PerformanceData;

  /**
   * Defines the provisioning states.
   */
  @visibility("read")
  provisioningState?: ProvisioningState;

  /**
   * Defines the errors related to SAP Instance resource.
   */
  @visibility("read")
  errors?: SAPMigrateError;
}

/**
 * Defines the request body for updating Server Instances resource.
 */
model UpdateServerInstanceRequest {
  /**
   * Server instances properties.
   */
  properties?: ServerInstanceProperties;
}

/**
 * The SAP instance specific configuration data.
 */
model ConfigurationData {
  /**
   * Provide the SAPS for each server of the SAP system. This should be a non-zero value. For example, 1000.
   */
  @visibility("read")
  saps?: int32;

  /**
   * Provide the CPU value of the server. For example, 16, 32 etc.
   */
  @visibility("read")
  cpu?: int32;

  /**
   * Provide the CPU architecture type of the server. For example, Xeon Platinum 8171M, Xeon E5-2673 v3.
   */
  @visibility("read")
  cpuType?: string;

  /**
   * Provide the CPU clock speed of the server in MHz. This should be a non-zero value. For example, 2100.
   */
  @visibility("read")
  cpuInMhz?: int32;

  /**
   * Provide the RAM of the server. This should be a non-zero value. For example, 256.
   */
  @visibility("read")
  ram?: int32;

  /**
   * Provide the HW manufacturer company of the server.  For example, Microsoft Corporation.
   */
  @visibility("read")
  hardwareManufacturer?: string;

  /**
   * Specify if the Hardware is a physical server or virtual machine.
   */
  @visibility("read")
  `model`?: string;

  /**
   * Provide the total disk volume capacity in GB. Add the disk volume for each individual disks and provide the total sum in this field.
   */
  #suppress "@azure-tools/typespec-azure-core/casing-style" "GB is short for Gigabytes."
  @visibility("read")
  totalDiskSizeGB?: int32;

  /**
   * Provide the total disk IOPS capacity. Add the disk volume for each individual disk and provide the sum total in this field.
   */
  @visibility("read")
  totalDiskIops?: int32;

  /**
   * The database of this is a server instance. Applicable only if SAP instance type for this server instance is 'DB'.
   */
  @visibility("read")
  databaseType?: DatabaseType;

  /**
   *  Provide the target HANA database size you need. Applicable only if SAP instance type for this server instance is 'DB' and you are migrating an AnyDb database to SAP S/4HANA.
   */
  #suppress "@azure-tools/typespec-azure-core/casing-style" "GB is short for Gigabytes."
  @visibility("read")
  targetHanaRamSizeGB?: int32;
}

/**
 * The SAP instance specific performance data.
 */
@discriminator("dataSource")
model PerformanceData {
  /** The data source of the performance data. */
  dataSource: DataSource;
}

/**
 * The SAP instance specific performance data for Excel import.
 */
model ExcelPerformanceData extends PerformanceData {
  /**
   * Provide the max CPU percentage load on the server. Omit the percentage symbol while filling this value.
   */
  @visibility("read")
  maxCpuLoad?: int32;

  /**
   * Provide the source Database size in GB. Applicable only if SAP instance type for this server instance is 'DB'.
   */
  #suppress "@azure-tools/typespec-azure-core/casing-style" "GB is short for Gigabytes."
  @visibility("read")
  totalSourceDbSizeGB?: int32;

  /**
   * The data source for this resource.
   */
  dataSource: DataSource.Excel;
}

/**
 * The SAP instance specific performance data for native discovery.
 */
model NativePerformanceData extends PerformanceData {
  /**
   * The data source for this resource.
   */
  dataSource: DataSource.Native;
}