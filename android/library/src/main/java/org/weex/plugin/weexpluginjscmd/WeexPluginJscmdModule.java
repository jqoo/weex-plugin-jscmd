package org.weex.plugin.weexpluginjscmd;

import android.content.Context;

import com.alibaba.fastjson.JSONObject;
import com.alibaba.weex.plugin.annotation.WeexModule;
import com.taobao.weex.WXSDKInstance;
import com.taobao.weex.annotation.JSMethod;
import com.taobao.weex.bridge.JSCallback;
import com.taobao.weex.common.WXModule;

import java.util.HashMap;

@WeexModule(name = "weexPluginJscmd")
public class WeexPluginJscmdModule extends WXModule {

    private static final String TAG = "WeexPluginJscmdModule";

    private static HashMap<WXSDKInstance, JSCallback> sHandler =new HashMap<>();
    private static HashMap<String, OnWeexCallback> sCallback;

    @JSMethod(uiThread = true)
    public void bindCmdHandler(JSCallback handler) {
        sHandler.put(mWXSDKInstance, handler);
    }

    @JSMethod(uiThread = false)
    public void setCmdResult(JSONObject result) {
        if (result == null) {
            return;
        }
        String cmdId = result.getString("id");
        OnWeexCallback callback = sCallback.get(cmdId);
        if (callback == null) {
            return;
        }
        JSONObject error = result.getJSONObject("error");
        Object object = result.get("data");
        callback.onCallback(error, object);
        sCallback.remove(cmdId);
    }

    /**
     * native 调用 weex
     *
     * @param cmd
     * @param args
     * @param callback
     * @param instance
     */
    public static void eval(String cmd, JSONObject args, OnWeexCallback callback, WXSDKInstance instance) {
        if (sCallback == null) {
            sCallback = new HashMap<>();
        }
        String cmdId = String.valueOf(System.currentTimeMillis());
        sCallback.put(cmdId, callback);
        if (sHandler == null || sHandler.get(instance) == null) {
            if (callback != null) {
                JSONObject jsonObject = new JSONObject();
                jsonObject.put("code", "-1");
                jsonObject.put("msg", "no implements");
                callback.onCallback(jsonObject, null);
            }
            return;
        }
        sHandler.get(instance).invokeAndKeepAlive(buildParams(cmdId, cmd, args));
    }

    private static JSONObject buildParams(String id, String cmd, JSONObject args) {
        JSONObject jsonObject = new JSONObject();
        jsonObject.put("id", id);
        jsonObject.put("cmd", cmd);
        jsonObject.put("args", args);
        return jsonObject;
    }

    /**
     * 清除当前页面绑定的方法
     * @param context
     */
    public static void destroy(Context context) {
        if (sHandler == null) {
            return;
        }
        sHandler.remove(context);
    }

    public interface OnWeexCallback {
        void onCallback(JSONObject error, Object data);
    }
}