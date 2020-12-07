const showSpinner = () => {
    $("#quotegenerator-spinner").removeClass("d-none");
}
const hideSpinner = () => {
    $("#quotegenerator-spinner").addClass("d-none");
}
const fetcher = (method, url, body) => {
    return new Promise((resolve, reject) => {
        showSpinner();
        const ctx = {
            "method": method,
            "credentials": "include",
            "cors": true,
            "headers": {
                "content-type": "application/json"
            }
        }
        if (body) ctx.body = JSON.stringify(body);
        fetch(url, ctx).then(res => res.json()).then(data => {
            resolve(data);
        }).catch(err => {
            reject(err);
        }).then(() => {
            hideSpinner();
        })
    })
}
const doGet = (url) => {
    return fetcher("GET", url);
}
const doPost = (url, body) => {
    return fetcher("POST", url, body);
}
window.startApp = () => {
        // let it snow!
        Snowflakes({
            count: 100
        });

        doGet("/api/productfamilies").then(data => {
                    $(`select[name="productfamily"]`).html(`${data.reduce((prev,p) => `${prev}<option value="${p.value}">${p.label}</option>`, "")}`);
        })
        $(`button`).on("click", (evt) => {
            evt.preventDefault = true;

            const fn = $(`input[name="fn"]`).val();
            const ln = $(`input[name="ln"]`).val();
            const company = $(`input[name="company"]`).val();
            const email = $(`input[name="email"]`).val();
            const product = $(`select[name="productfamily"]`).val();
            
            // submit
            doPost("/api/createlead", {
                fn,
                ln,
                company,
                email,
                product
            }).then(data => {
                $("#main-body").html(`<h1>Thank you ${fn}!</h1><div>We've registered your interest in ${product} and will be in touch shortly.`);
            })
        })
}