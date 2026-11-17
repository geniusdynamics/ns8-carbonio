<!--
  Copyright (C) 2026 Genius Dynamics
  SPDX-License-Identifier: GPL-3.0-or-later
-->
<template>
  <cv-grid fullWidth>
    <cv-row>
      <cv-column class="page-title">
        <h2>{{ $t("settings.title") }}</h2>
      </cv-column>
    </cv-row>
    <cv-row v-if="error.getConfiguration">
      <cv-column>
        <NsInlineNotification
          kind="error"
          :title="$t('action.get-configuration')"
          :description="error.getConfiguration"
          :showCloseButton="false"
        />
      </cv-column>
    </cv-row>
    <cv-row>
      <cv-column>
        <cv-tile light>
          <cv-form @submit.prevent="configureModule">
            <!-- Server role -->
            <h4 class="mg-bottom-sm">{{ $t("settings.server_role") }}</h4>
            <cv-radio-group vertical class="mg-bottom">
              <cv-radio-button
                v-for="option in roleOptions"
                :key="option"
                v-model="clusterRole"
                :value="option"
                :label="$t('settings.role_' + option)"
                :disabled="stillLoading || !canChangeRole(option)"
                ref="cluster_role"
              />
            </cv-radio-group>
            <p class="mg-bottom helper">
              {{ $t("settings.role_" + clusterRole + "_description") }}
            </p>
            <NsInlineNotification
              v-if="error.cluster_role"
              kind="error"
              :title="$t('settings.server_role')"
              :description="error.cluster_role"
              :showCloseButton="false"
            />
            <template v-if="clusterRole === 'worker'">
              <NsComboBox
                v-model="join"
                :options="masterOptions"
                :title="$t('settings.join')"
                :label="$t('settings.join_placeholder')"
                :invalid-message="error.join"
                :disabled="stillLoading || initialized"
                :autoFilter="true"
                :autoHighlight="true"
                class="mg-bottom"
                ref="join"
              />
              <NsInlineNotification
                v-if="!masterOptions.length && !initialized"
                kind="info"
                :title="$t('settings.no_masters')"
                :description="$t('settings.no_masters_description')"
                :showCloseButton="false"
              />
            </template>
            <NsToggle
              v-if="clusterRole === 'master'"
              value="acceptJoin"
              :label="$t('settings.accept_join')"
              v-model="acceptJoin"
              :disabled="stillLoading"
              class="mg-bottom"
            >
              <template slot="text-left">{{
                $t("settings.disabled")
              }}</template>
              <template slot="text-right">{{
                $t("settings.enabled")
              }}</template>
            </NsToggle>

            <!-- Host and mail domain -->
            <NsTextInput
              :label="$t('settings.host')"
              placeholder="mail.example.org"
              v-model.trim="host"
              class="mg-bottom"
              :invalid-message="error.host"
              :helper-text="$t('settings.host_helper')"
              :disabled="stillLoading || initialized"
              ref="host"
            />
            <template v-if="clusterRole !== 'worker'">
              <NsTextInput
                :label="$t('settings.mail_domain')"
                placeholder="example.org"
                v-model.trim="mailDomain"
                class="mg-bottom"
                :invalid-message="error.mail_domain"
                :helper-text="$t('settings.mail_domain_helper')"
                :disabled="stillLoading || initialized"
                ref="mail_domain"
              />
              <NsTextInput
                :label="$t('settings.admin_user')"
                v-model.trim="adminUser"
                class="mg-bottom"
                :invalid-message="error.admin_user"
                :disabled="stillLoading || initialized"
                ref="admin_user"
              />
              <NsTextInput
                type="password"
                :label="
                  initialized
                    ? $t('settings.admin_password_change')
                    : $t('settings.admin_password')
                "
                v-model="adminPassword"
                class="mg-bottom"
                :invalid-message="error.admin_password"
                :helper-text="$t('settings.admin_password_helper')"
                :disabled="stillLoading"
                autocomplete="new-password"
                ref="admin_password"
              />
            </template>
            <NsToggle
              value="letsEncrypt"
              :label="core.$t('apps_lets_encrypt.request_https_certificate')"
              v-model="isLetsEncryptEnabled"
              :disabled="stillLoading"
              class="mg-bottom"
            >
              <template #tooltip>
                <div class="mg-bottom-sm">
                  {{ $t("settings.lets_encrypt_tips") }}
                </div>
                <div class="mg-bottom-sm">
                  <cv-link @click="goToCertificates">
                    {{ core.$t("apps_lets_encrypt.go_to_tls_certificates") }}
                  </cv-link>
                </div>
              </template>
              <template slot="text-left">{{
                $t("settings.disabled")
              }}</template>
              <template slot="text-right">{{
                $t("settings.enabled")
              }}</template>
            </NsToggle>
            <NsToggle
              value="httpToHttps"
              :label="$t('settings.http_to_https')"
              v-model="isHttpToHttpsEnabled"
              :disabled="stillLoading"
              class="mg-bottom"
            >
              <template slot="text-left">{{
                $t("settings.disabled")
              }}</template>
              <template slot="text-right">{{
                $t("settings.enabled")
              }}</template>
            </NsToggle>

            <!-- Features -->
            <h4 class="mg-bottom-sm">{{ $t("settings.features") }}</h4>
            <NsToggle
              v-if="clusterRole !== 'worker'"
              value="antivirus"
              :label="$t('settings.antivirus')"
              v-model="antivirus"
              :disabled="stillLoading"
              class="mg-bottom"
            >
              <template #tooltip>{{
                $t("settings.antivirus_tooltip")
              }}</template>
              <template slot="text-left">{{
                $t("settings.disabled")
              }}</template>
              <template slot="text-right">{{
                $t("settings.enabled")
              }}</template>
            </NsToggle>
            <NsInlineNotification
              v-if="antivirus && clusterRole !== 'worker'"
              kind="info"
              :title="$t('settings.ram_note')"
              :description="$t('settings.antivirus_ram')"
              :showCloseButton="false"
            />
            <NsToggle
              v-for="feature in futureFeatures"
              :key="feature"
              :value="feature"
              :label="$t('settings.feature_' + feature)"
              v-model="comingSoonOff"
              :disabled="true"
              class="mg-bottom"
            >
              <template #tooltip>{{
                $t("settings.coming_soon_tooltip")
              }}</template>
              <template slot="text-left">{{
                $t("settings.coming_soon")
              }}</template>
              <template slot="text-right">{{
                $t("settings.enabled")
              }}</template>
            </NsToggle>

            <!-- advanced options -->
            <cv-accordion ref="accordion" class="maxwidth mg-bottom">
              <cv-accordion-item :open="toggleAccordion[0]">
                <template slot="title">{{ $t("settings.advanced") }}</template>
                <template slot="content">
                  <NsTextInput
                    v-if="clusterRole !== 'worker'"
                    :label="$t('settings.admin_host')"
                    placeholder="mailadmin.example.org"
                    v-model.trim="adminHost"
                    class="mg-bottom"
                    :invalid-message="error.admin_host"
                    :helper-text="$t('settings.admin_host_helper')"
                    :disabled="stillLoading"
                    ref="admin_host"
                  />
                  <NsTextInput
                    :label="$t('settings.mailbox_heap_mb')"
                    v-model.number="mailboxHeapMb"
                    type="number"
                    class="mg-bottom"
                    :invalid-message="error.mailbox_heap_mb"
                    :helper-text="$t('settings.mailbox_heap_mb_helper')"
                    :disabled="stillLoading"
                    ref="mailbox_heap_mb"
                  />
                  <NsTextInput
                    :label="$t('settings.timezone')"
                    v-model.trim="timezone"
                    class="mg-bottom"
                    :invalid-message="error.timezone"
                    :disabled="stillLoading"
                    ref="timezone"
                  />
                </template>
              </cv-accordion-item>
            </cv-accordion>
            <NsInlineNotification
              v-if="!initialized"
              kind="info"
              :title="$t('settings.first_setup')"
              :description="$t('settings.first_setup_description')"
              :showCloseButton="false"
            />
            <NsProgressBar
              v-if="loading.configureModule"
              :value="configureProgress"
              :indeterminate="!configureProgress"
              class="mg-bottom"
            />
            <cv-row v-if="error.configureModule">
              <cv-column>
                <NsInlineNotification
                  kind="error"
                  :title="$t('action.configure-module')"
                  :description="error.configureModule"
                  :showCloseButton="false"
                />
              </cv-column>
            </cv-row>
            <cv-row v-if="validationErrorDetails.length">
              <cv-column>
                <NsInlineNotification
                  kind="error"
                  :title="
                    core.$t('apps_lets_encrypt.cannot_obtain_certificate')
                  "
                  :showCloseButton="false"
                >
                  <template #description>
                    <div
                      v-for="(detail, index) in validationErrorDetails"
                      :key="index"
                    >
                      {{ detail }}
                    </div>
                  </template>
                </NsInlineNotification>
              </cv-column>
            </cv-row>
            <NsButton
              kind="primary"
              :icon="Save20"
              :loading="loading.configureModule"
              :disabled="stillLoading"
              >{{ $t("settings.save") }}</NsButton
            >
          </cv-form>
        </cv-tile>
      </cv-column>
    </cv-row>
  </cv-grid>
</template>

<script>
import to from "await-to-js";
import { mapState } from "vuex";
import {
  QueryParamService,
  UtilService,
  TaskService,
  IconService,
  PageTitleService,
} from "@nethserver/ns8-ui-lib";

export default {
  name: "Settings",
  mixins: [
    TaskService,
    IconService,
    UtilService,
    QueryParamService,
    PageTitleService,
  ],
  pageTitle() {
    return this.$t("settings.title") + " - " + this.appName;
  },
  data() {
    return {
      q: {
        page: "settings",
      },
      urlCheckInterval: null,
      roleOptions: ["standalone", "master", "worker"],
      futureFeatures: ["files", "docs", "preview", "chats"],
      comingSoonOff: false,
      validationErrorDetails: [],
      configureProgress: 0,
      initialized: false,
      currentRole: "standalone",
      clusterRole: "standalone",
      join: "",
      availableMasters: [],
      acceptJoin: true,
      host: "",
      mailDomain: "",
      adminUser: "admin",
      adminPassword: "",
      adminHost: "",
      antivirus: true,
      mailboxHeapMb: 1536,
      timezone: "",
      isLetsEncryptEnabled: false,
      isHttpToHttpsEnabled: true,
      loading: {
        getConfiguration: false,
        configureModule: false,
      },
      error: {
        getConfiguration: "",
        configureModule: "",
        host: "",
        cluster_role: "",
        join: "",
        mail_domain: "",
        admin_user: "",
        admin_password: "",
        admin_host: "",
        mailbox_heap_mb: "",
        timezone: "",
        lets_encrypt: "",
        http2https: "",
        features: "",
      },
    };
  },
  computed: {
    ...mapState(["instanceName", "core", "appName"]),
    stillLoading() {
      return this.loading.getConfiguration || this.loading.configureModule;
    },
    masterOptions() {
      return this.availableMasters.map((m) => ({
        name: m.module_id,
        value: m.module_id,
        label: `${m.fqdn} (${m.module_id}, ${this.$t("settings.node")} ${
          m.node
        })`,
      }));
    },
  },
  created() {
    this.getConfiguration();
  },
  beforeRouteEnter(to, from, next) {
    next((vm) => {
      vm.watchQueryData(vm);
      vm.urlCheckInterval = vm.initUrlBindingForApp(vm, vm.q.page);
    });
  },
  beforeRouteLeave(to, from, next) {
    clearInterval(this.urlCheckInterval);
    next();
  },
  methods: {
    goToCertificates() {
      this.core.$router.push("/settings/tls-certificates");
    },
    canChangeRole(option) {
      // A worker holds the data of another directory: its role is fixed.
      // Standalone and master servers can switch between them.
      if (!this.initialized) {
        return true;
      }
      if (this.currentRole === "worker") {
        return option === "worker";
      }
      return option !== "worker";
    },
    async getConfiguration() {
      this.loading.getConfiguration = true;
      this.error.getConfiguration = "";
      const taskAction = "get-configuration";
      const eventId = this.getUuid();
      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.getConfigurationAborted
      );
      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.getConfigurationCompleted
      );
      const res = await to(
        this.createModuleTaskForApp(this.instanceName, {
          action: taskAction,
          extra: {
            title: this.$t("action." + taskAction),
            isNotificationHidden: true,
            eventId,
          },
        })
      );
      const err = res[0];
      if (err) {
        console.error(`error creating task ${taskAction}`, err);
        this.error.getConfiguration = this.getErrorMessage(err);
        this.loading.getConfiguration = false;
      }
    },
    getConfigurationAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.error.getConfiguration = this.$t("error.generic_error");
      this.loading.getConfiguration = false;
    },
    getConfigurationCompleted(taskContext, taskResult) {
      const config = taskResult.output;
      this.initialized = config.initialized;
      this.currentRole = config.cluster_role;
      this.clusterRole = config.cluster_role;
      this.join = config.join || "";
      this.availableMasters = config.available_masters || [];
      this.acceptJoin = config.accept_join;
      this.host = config.host;
      this.mailDomain = config.mail_domain;
      this.adminUser = config.admin_user || "admin";
      this.adminPassword = "";
      this.adminHost = config.admin_host || "";
      this.antivirus = config.antivirus;
      this.mailboxHeapMb = config.mailbox_heap_mb;
      this.timezone = config.timezone;
      this.isLetsEncryptEnabled = config.lets_encrypt;
      this.isHttpToHttpsEnabled = config.http2https;
      this.loading.getConfiguration = false;
      this.focusElement("host");
    },
    validateConfigureModule() {
      this.clearErrors(this);
      this.validationErrorDetails = [];
      let ok = true;
      const fail = (field, message) => {
        this.error[field] = message;
        if (ok) {
          this.focusElement(field);
        }
        ok = false;
      };
      if (!this.host) {
        fail("host", this.$t("common.required"));
      }
      if (this.clusterRole === "worker" && !this.join) {
        fail("join", this.$t("common.required"));
      }
      if (
        this.clusterRole !== "worker" &&
        !this.initialized &&
        !this.adminPassword
      ) {
        fail("admin_password", this.$t("common.required"));
      }
      if (this.adminPassword && this.adminPassword.length < 10) {
        fail("admin_password", this.$t("settings.admin_password_short"));
      }
      return ok;
    },
    configureModuleValidationFailed(validationErrors) {
      this.loading.configureModule = false;
      this.core.$root.$off(
        `configure-module-progress-${this.configureEventId}`
      );
      let focusAlreadySet = false;
      for (const validationError of validationErrors) {
        const param = validationError.parameter;
        if (validationError.details) {
          this.validationErrorDetails = validationError.details
            .split("\n")
            .filter((detail) => detail.trim() !== "");
        } else {
          this.error[param] = this.$t("settings." + validationError.error, {
            value: validationError.value,
          });
          if (!focusAlreadySet) {
            this.focusElement(param);
            focusAlreadySet = true;
          }
        }
      }
    },
    async configureModule() {
      if (!this.validateConfigureModule()) {
        return;
      }
      this.loading.configureModule = true;
      this.configureProgress = 0;
      const taskAction = "configure-module";
      const eventId = this.getUuid();
      this.configureEventId = eventId;
      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.configureModuleAborted
      );
      this.core.$root.$once(
        `${taskAction}-validation-failed-${eventId}`,
        this.configureModuleValidationFailed
      );
      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.configureModuleCompleted
      );
      this.core.$root.$on(
        `${taskAction}-progress-${eventId}`,
        this.configureModuleProgress
      );
      const data = {
        host: this.host,
        lets_encrypt: this.isLetsEncryptEnabled,
        http2https: this.isHttpToHttpsEnabled,
        cluster_role: this.clusterRole,
        mailbox_heap_mb: Number(this.mailboxHeapMb),
        timezone: this.timezone,
      };
      if (this.clusterRole === "worker") {
        data.join = this.join;
      } else {
        data.antivirus = this.antivirus;
        data.admin_host = this.adminHost;
        if (this.clusterRole === "master") {
          data.accept_join = this.acceptJoin;
        }
        if (!this.initialized) {
          data.mail_domain =
            this.mailDomain || this.host.split(".").slice(1).join(".");
          data.admin_user = this.adminUser;
        }
        if (this.adminPassword) {
          data.admin_password = this.adminPassword;
        }
      }
      const res = await to(
        this.createModuleTaskForApp(this.instanceName, {
          action: taskAction,
          data,
          extra: {
            title: this.$t("settings.instance_configuration", {
              instance: this.instanceName,
            }),
            description: this.$t("settings.configuring"),
            isProgressNotified: true,
            eventId,
          },
        })
      );
      const err = res[0];
      if (err) {
        console.error(`error creating task ${taskAction}`, err);
        this.error.configureModule = this.getErrorMessage(err);
        this.loading.configureModule = false;
        this.core.$root.$off(`${taskAction}-progress-${eventId}`);
      }
    },
    configureModuleProgress(progress) {
      this.configureProgress = progress;
    },
    configureModuleAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.core.$root.$off(
        `${taskContext.action}-progress-${taskContext.extra.eventId}`
      );
      this.error.configureModule = this.$t("error.generic_error");
      this.loading.configureModule = false;
    },
    configureModuleCompleted(taskContext) {
      this.core.$root.$off(
        `${taskContext.action}-progress-${taskContext.extra.eventId}`
      );
      this.loading.configureModule = false;
      this.getConfiguration();
    },
  },
};
</script>

<style scoped lang="scss">
@import "../styles/carbon-utils";
.mg-bottom {
  margin-bottom: $spacing-06;
}

.mg-bottom-sm {
  margin-bottom: $spacing-03;
}

.maxwidth {
  max-width: 38rem;
}

.helper {
  max-width: 38rem;
}
</style>
