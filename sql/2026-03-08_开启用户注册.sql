-- 开启用户注册功能
UPDATE sys_config SET config_value = 'true'
WHERE config_key = 'sys.account.registerUser';
