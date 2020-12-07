({
    doInit: function(cmp, evt, helper) {
        const renderCanvas = $A.getCallback(() => {
            const recordId = cmp.get("v.recordId");
            if (!recordId) {
                window.setTimeout(renderCanvas, 200);
                return;
            }
            cmp.set("v.canvasParameters", JSON.stringify({
                "recordId": recordId
            }));
        })
        window.setTimeout(renderCanvas, 200);
    }
})