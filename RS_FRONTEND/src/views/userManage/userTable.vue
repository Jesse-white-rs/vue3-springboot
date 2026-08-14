<template>
  <div class="table-wrapper">
    <el-table
      :data="store.tableData"
      style="width: 100%"
      height="60vh"
      @selection-change="store.handleSelectionChange"
      class="ios-table"
    >
      <el-table-column type="selection" width="40" />
      <el-table-column fixed prop="emp.eAvatarpath" label="头像" width="70">
        <template #default="scope">
          <el-avatar :size="32" :src="scope.row.emp.eAvatarpath" />
        </template>
      </el-table-column>
      <el-table-column
        fixed
        prop="emp.id"
        label="ID"
        sortable
        width="65"
        show-overflow-tooltip
      />
      <el-table-column
        fixed
        prop="emp.eName"
        label="姓名"
        width="90"
        show-overflow-tooltip
      >
        <template #default="scope">
          <el-tag effect="plain" round size="small">{{
            scope.row.emp.eName
          }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column
        label="状态"
        width="80"
        :filters="[
          { text: '在线', value: '1' },
          { text: '离线', value: '0' },
        ]"
        :filter-method="(value: string, row: UserData) => row.isOnline == value"
        filter-placement="bottom-end"
      >
        <template #default="scope">
          <el-tag
            :type="scope.row.isOnline == '1' ? 'success' : 'info'"
            effect="dark"
            round
            size="small"
          >
            {{ scope.row.isOnline == "1" ? "在线" : "离线" }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column
        prop="emp.eUsername"
        label="账号"
        width="110"
        show-overflow-tooltip
      />
      <el-table-column
        prop="emp.ePassword"
        label="密码"
        width="80"
        show-overflow-tooltip
      >
        <template #default="scope">
          <el-popover trigger="hover" placement="top-start" width="auto">
            <template #reference>
              <span>{{ maskedPassword }}</span>
            </template>
            <div>{{ scope.row.emp.ePassword }}</div>
          </el-popover>
        </template>
      </el-table-column>
      <el-table-column
        prop="emp.eIsenabled"
        label="帐号状态"
        width="90"
        :filters="[
          { text: '启用', value: 1 },
          { text: '禁用', value: 0 },
        ]"
        :filter-method="(value: number, row: UserData) => row.emp.eIsenabled === value"
        filter-placement="bottom-end"
      >
        <template #default="scope">
          <el-tag
            :type="scope.row.emp.eIsenabled == '0' ? 'danger' : 'success'"
            size="small"
          >
            {{ scope.row.emp.eIsenabled == "0" ? "禁用" : "启用" }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column
        prop="emp.ePhone"
        label="手机号"
        width="120"
        show-overflow-tooltip
      >
        <template #default="scope">
          <div style="display: flex; align-items: center">
            <el-icon color="#34c759"><Iphone /></el-icon>
            <span style="margin-left: 6px">{{ scope.row.emp.ePhone }}</span>
          </div>
        </template>
      </el-table-column>
      <el-table-column
        prop="emp.eId"
        label="证件号"
        width="120"
        show-overflow-tooltip
      />
      <el-table-column
        prop="dept.dName"
        label="部门"
        width="100"
        show-overflow-tooltip
        :filters="deptFilters"
        :filter-method="(value: number, row: UserData) => row.dept.id === value"
        filter-placement="bottom-end"
      />
      <el-table-column prop="emp.eAge" label="年龄" width="60" />
      <el-table-column
        prop="emp.eGender"
        label="性别"
        width="70"
        :filters="[
          { text: '男', value: '1' },
          { text: '女', value: '0' },
        ]"
        :filter-method="(value: string, row: UserData) => row.emp.eGender == value"
        filter-placement="bottom-end"
      >
        <template #default="scope">
          <el-tag
            effect="dark"
            round
            size="small"
            :type="scope.row.emp.eGender == '1' ? 'primary' : 'danger'"
          >
            {{ scope.row.emp.eGender == "1" ? "♂" : "♀" }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column
        prop="emp.eCreatetime"
        label="创建日期"
        width="110"
        show-overflow-tooltip
        sortable
      >
        <template #default="scope">
          {{ formatDate(scope.row.emp.eCreatetime) }}
        </template>
      </el-table-column>
      <el-table-column
        prop="emp.eUpdatetime"
        label="更新日期"
        width="110"
        show-overflow-tooltip
        sortable
      >
        <template #default="scope">
          {{ formatDate(scope.row.emp.eUpdatetime) }}
        </template>
      </el-table-column>
      <el-table-column fixed="right" label="操作" min-width="120">
        <template #default="{ row }">
          <el-button
            size="small"
            type="primary"
            link
            @click="handleEditClick(row)"
            >修改</el-button
          >
          <el-button
            size="small"
            type="danger"
            link
            @click="handleDeleteClick(row.emp.id)"
            >删除</el-button
          >
        </template>
      </el-table-column>
    </el-table>
  </div>

  <userDataEdit
    :visible="editVisible"
    @update:visible="handleEditVisibleChange"
  />
  <userDataAdd :visible="addVisible" @update:visible="handleAddVisibleChange" />

  <!-- 删除确认弹窗 -->
  <Teleport to="body">
    <div
      v-show="confirmVisible"
      class="modal-overlay"
      @click.self="handleCancel"
    >
      <Transition name="vp-modal">
        <div v-show="confirmVisible" class="modal-container" @click.stop>
          <div class="modal-content-wrapper">
            <div class="modal-header">
              <h3 class="modal-title">确认删除？</h3>
              <div class="modal-close" @click="handleCancel">
                <svg
                  width="14"
                  height="14"
                  viewBox="0 0 12 12"
                  fill="currentColor"
                >
                  <path
                    d="M7.426 6l4.237-4.237a1 1 0 00-1.414-1.414L6 4.586 1.763.349A1 1 0 00.349 1.763L4.586 6 .349 10.237a1 1 0 001.414 1.414L6 7.426l4.237 4.237a1 1 0 001.414-1.414L7.426 6z"
                  />
                </svg>
              </div>
            </div>
            <div class="modal-content">
              <p class="confirm-text">此操作将不可逆，确定要删除吗？</p>
            </div>
            <div class="modal-footer">
              <div class="form-actions">
                <button
                  type="button"
                  class="ios-btn secondary"
                  @click="handleCancel"
                >
                  取消
                </button>
                <button
                  type="button"
                  class="ios-btn danger"
                  @click="handleDelete(delId)"
                >
                  确认删除
                </button>
              </div>
            </div>
          </div>
        </div>
      </Transition>
    </div>
  </Teleport>
</template>

<script lang="ts" setup>
import { ref, onMounted } from "vue";
import { formatDate } from "@/utils/moment";
import userDataEdit from "./userDataEdit.vue";
import userDataAdd from "./userDataAdd.vue";
import { useUserStore } from "@/stores/user-store";
import type { UserData } from "@/types/userTypes";
import { useRoleStore } from "@/stores/role-store";
import { useDeptStore } from "@/stores/dept-store";

const store = useUserStore();
const roleStore = useRoleStore();
const deptStore = useDeptStore();
const deptFilters = ref();
const delId = ref();
const confirmVisible = ref(false);
const maskedPassword = "已加密";

const props = defineProps<{
  addVisible: boolean;
}>();

const emit = defineEmits(["update:addVisible"]);

const editVisible = ref(false);

const handleDeleteClick = (id: number) => {
  confirmVisible.value = true;
  delId.value = id;
};

const handleCancel = () => {
  confirmVisible.value = false;
};

const handleAddVisibleChange = () => {
  emit("update:addVisible");
};

const handleEditVisibleChange = () => {
  editVisible.value = false;
};

const handleEditClick = (row: any) => {
  store.userDataFormData = { ...row };
  editVisible.value = true;
};

const handleDelete = async (id: number) => {
  store.handleDelete(id);
  confirmVisible.value = false;
};

onMounted(async () => {
  await roleStore.getRoleListAll();
  await deptStore.getAllDeptData().then(() => {
    deptFilters.value = deptStore.tableData.map((dept) => ({
      text: dept.dName,
      value: dept.id,
    }));
  });
});
</script>

<style scoped>
.table-wrapper {
  border-radius: 14px;
  overflow: hidden;
  border: 0.5px solid rgba(0, 0, 0, 0.06);
}

.ios-table :deep(.el-table__header th) {
  background: #f9f9f9 !important;
  font-weight: 600;
  color: #8e8e93;
  font-size: 12px;
}

.ios-table :deep(.el-table__row td) {
  border-bottom-color: rgba(0, 0, 0, 0.04);
}

.ios-table :deep(.el-table__row:hover > td) {
  background: #f5f9ff !important;
}

/* 删除确认弹窗 */
.modal-overlay {
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.25);
  backdrop-filter: blur(12px);
  -webkit-backdrop-filter: blur(12px);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 3000;
}

.modal-container {
  position: relative;
  width: 400px;
  max-width: 90vw;
}

.modal-content-wrapper {
  background: #fff;
  border-radius: 25px;
  overflow: hidden;
  border: 0.5px solid rgba(0, 0, 0, 0.06);
  box-shadow: 0 24px 80px rgba(0, 0, 0, 0.15);
}

.modal-header {
  padding: 5px 20px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  border-bottom: 0.5px solid rgba(0, 0, 0, 0.06);
}

.modal-title {
  font-size: 18px;
  font-weight: 600;
  color: #1f1f1f;
}

.modal-close {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 32px;
  height: 32px;
  border-radius: 50%;
  background: rgba(0, 0, 0, 0.04);
  transition: all 0.3s ease;
  cursor: pointer;
  color: #6e6e73;
}

.modal-close:hover {
  background: rgba(255, 59, 48, 0.12);
  color: #ff3b30;
}

.modal-content {
  padding: 24px 20px;
}

.confirm-text {
  font-size: 15px;
  color: #6e6e73;
  margin: 0;
  text-align: center;
}

.modal-footer {
  padding: 16px 20px;
  border-top: 0.5px solid rgba(0, 0, 0, 0.06);
}

.form-actions {
  display: flex;
  gap: 12px;
}

.ios-btn {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 12px 24px;
  border: none;
  border-radius: 12px;
  font-size: 15px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
}

.ios-btn.secondary {
  background: rgba(0, 0, 0, 0.06);
  color: #1d1d1f;
}

.ios-btn.secondary:hover {
  background: rgba(0, 0, 0, 0.1);
}

.ios-btn.danger {
  background: #ff3b30;
  color: #fff;
  box-shadow: 0 4px 12px rgba(255, 59, 48, 0.3);
}

.ios-btn.danger:hover {
  background: #e6352c;
  transform: translateY(-1px);
}

.ios-btn.danger:active {
  transform: scale(0.97);
}

/* 动画 */
.vp-modal-enter-active {
  animation: vp-modal-in 0.35s cubic-bezier(0.22, 1, 0.36, 1);
}

.vp-modal-leave-active {
  animation: vp-modal-out 0.2s ease;
}

@keyframes vp-modal-in {
  0% {
    transform: scale(0.95);
    opacity: 0;
  }
  100% {
    transform: scale(1);
    opacity: 1;
  }
}

@keyframes vp-modal-out {
  0% {
    transform: scale(1);
    opacity: 1;
  }
  100% {
    transform: scale(0.95);
    opacity: 0;
  }
}
</style>
