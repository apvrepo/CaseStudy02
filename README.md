# Salesforce DX Project: Next Steps

Now that you’ve created a Salesforce DX project, what’s next? Here are some documentation resources to get you started.

## Project Overview

This project includes the following components:
- **Apex Classes**: Business logic and helper classes.
- **Apex Triggers**: Automation logic for Salesforce objects.
- **Lightning Web Components (LWC)**: Custom UI components.
- **Custom Labels**: Labels used in the UI components.
- **Custom Objects**: Custom objects and fields.

### Apex Classes
- **AccountHelper**: Contains methods to update account-related counts and roles.
- **AccountContactRelationTriggerHandler**: Trigger handler for `AccountContactRelation` object.
- **ContactTriggerHandler**: Trigger handler for `Contact` object.
- **OpportunityTriggerHandler**: Trigger handler for `Opportunity` object.
- **InitializeAccountSums**: Batch class to initialize account sums fields.
- **TestDataFactory**: Utility class to create test data for unit tests.
- **AccountHelperTest**: Unit test class for `AccountHelper`.

### Lightning Web Components (LWC)
- **lWCAccountCardTabSet**: Custom component to display account-related information.
- **lWCPage**: Custom component to display a list of account records.

### Custom Labels
- **AnnualRevenueLabel**
- **BusinessUsersLabel**
- **ContactRelationsLabel**
- **ContactsLabel**
- **CreatedDateLabel**
- **DecisionMakersLabel**
- **OpportunitiesLabel**
- **TickerSymbolLabel**

## Configure Your Salesforce DX Project

The `sfdx-project.json` file contains useful configuration information for your project. See [Salesforce DX Project Configuration](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_ws_config.htm) in the _Salesforce DX Developer Guide_ for details about this file.

## Deployment Guide

### Prerequisites

1. **Salesforce CLI**: Ensure you have the Salesforce CLI installed. You can download it from [Salesforce CLI Setup Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_intro.htm).
2. **Salesforce DX Project**: Ensure you have a Salesforce DX project set up.

### Steps to Deploy Metadata into a Fresh Org

1. **Authenticate to Your Org**:
    ```sh
    sfdx auth:web:login -a MyDevOrg
    ```

2. **Create a Scratch Org** (optional):
    ```sh
    sfdx force:org:create -s -f config/project-scratch-def.json -a MyScratchOrg
    ```

3. **Push Source to Scratch Org** (if using a scratch org):
    ```sh
    sfdx force:source:push -u MyScratchOrg
    ```

4. **Deploy Source to a Non-Scratch Org**:
    ```sh
    sfdx force:source:deploy -p force-app -u MyDevOrg
    ```

5. **Assign Permission Sets** (if any):
    ```sh
    sfdx force:user:permset:assign -n MyPermissionSet -u MyDevOrg
    ```

6. **Run Apex Tests**:
    ```sh
    sfdx force:apex:test:run -u MyDevOrg --codecoverage --resultformat human
    ```

7. **Open the Org**:
    ```sh
    sfdx force:org:open -u MyDevOrg
    ```

## Read All About It

- [Salesforce Extensions Documentation](https://developer.salesforce.com/tools/vscode/)
- [Salesforce CLI Setup Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_intro.htm)
- [Salesforce DX Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_intro.htm)
- [Salesforce CLI Command Reference](https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference.htm)
