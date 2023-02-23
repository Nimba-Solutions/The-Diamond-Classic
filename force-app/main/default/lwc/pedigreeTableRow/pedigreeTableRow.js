<template>
  <table>
    <tr>
      <td>
        <div class="slds-grid slds-wrap">
          <div class="slds-col slds-small-size_6-of-12 slds-medium-size_12-of-12 slds-large-size_6-of-12">
            <div class="input-fields slds-wrap ">
              <lightning-input type="text" name="Name__c" placeholder="Name" variant="label-hidden" value={horse.Name__c} onchange={handleOnChange} required onblur={handleUnfocus} style="width: 130px;"></lightning-input>
              <lightning-input type="text" name="Registration_Number__c" placeholder="Reg No." variant="label-hidden" value={horse.Registration_Number__c} required onblur={handleUnfocus} onchange={handleOnChange} style="width: 130px;"></lightning-input>
              <lightning-combobox name="Gender__c" placeholder="Gender" variant="label-hidden" value={horse.Gender__c} options={genderOptions} onblur={handleUnfocus} onchange={handleOnChange} style="width: 130px;"></lightning-combobox>
              <lightning-input type="date" name="Date_Foaled__c" placeholder="Date Foaled" variant="label-hidden" value={horse.Date_Foaled__c} onblur={handleUnfocus} onchange={handleOnChange} style="width: 130px;"></lightning-input>
              <lightning-input type="text" name="Color__c" placeholder="Color" variant="label-hidden" value={horse.Color__c} onblur={handleUnfocus} onchange={handleOnChange} style="width: 130px;"></lightning-input>
              <c-lookup style="width: 130px;"
                        onsearch={handleSearch}
                        onselectionchange={handleSelectionChange}
                        name="sire"
                        placeholder="Sire..."
                        class="sire">
              </c-lookup>
              <c-lookup style="width: 130px;"
                        onsearch={handleSearch}
                        onselectionchange={handleSelectionChange}
                        name="dam"
                        placeholder="Dam..."
                        class="dam">
              </c-lookup>
            </div>
          </div>
          <div class="slds-col slds-small-size_12-of-12 slds-medium-size_6-of-12 slds-large-size_3-of-12">
            <div class="checkbox-group">
              <div class="left">
                  <lightning-input name="AQHA__c" label="AQHA" type="checkbox" onchange={handleOnChange} uncheck> </lightning-input>
                  <lightning-input name="APHA__c" label="APHA" type="checkbox" onchange={handleOnChange} uncheck> </lightning-input>
                  <lightning-input name="APHC__c" label="APHC" type="checkbox" onchange={handleOnChange} uncheck> </lightning-input>
                  <lightning-input name="TB__c" label="TB" type="checkbox" onchange={handleOnChange} uncheck> </lightning-input>
                </div>
                <div>
                  <div class="right">
                    <lightning-input type="checkbox" label="Competing?" name="IsCompeting__c" onchange={handleOnChange} uncheck> </lightning-input>
                    </br>
                    <lightning-input type="checkbox" label="Other" name="Other__c" onchange={handleOnChange} uncheck> </lightning-input>
                    <lightning-input type="text" label="Other" name="Other_Breed_Association__c" onblur={handleUnfocus} variant="label-hidden" value={horse.Other_Breed_Association__c} onchange={handleOnChange}></lightning-input>
                  </div>
                </div>
              </div>
            </div>
            <div class="slds-col slds-small-size_12-of-12 slds-medium-size_6-of-12 slds-large-size_3-of-12">
              <div class="input-fields">
                <lightning-file-upload label="Upload"
                                      multiple="true"
                                      record-id={horse.Id}
                                      file-field-name="Guest_Record_fileupload__c"
                                      file-field-value={encryptedToken}
                                      onuploadfinished={handleUploadFinished}
                                      class="slds-col slds-size_1-of-2">
                </lightning-file-upload>
              </div>
            </div>
          </div>
        </td>
        <td>
            <lightning-button-icon class="slds-m-left_x_large slds-col slds-size_2-of-12" icon-name="utility:delete" variant="border-filled" onclick={removeRow} data-key={horse.id}></lightning-button-icon>
        </td>
    </tr>
  </table>
</template>
