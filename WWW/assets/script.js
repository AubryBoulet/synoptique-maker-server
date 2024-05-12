function handleChoseFileClick(e) {
    const file = e.currentTarget.files[0]
    console.log(file)
    fetch("api/testfile",{
        method: "POST",
        headers: {
            "Content-Name": file.name
        },
        body: file
    })
}

function handleSendFileClick() {
    console.log("send clicked")
}

function handleSendJsonClick() {
    console.log("send json");
    let credential = {
        name: "Test prout zizi bite",
        count: 10,
        zizi: true,
    };
    fetch("api/test",{
        method: "POST",
        headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify(credential)
    })
    .then((value)=>{
        return value.json();
    })
    .then((data)=>{
        console.log(data);
    });
}

function init() {
    console.log("hello world");
    document.querySelector("#chose").addEventListener("change",handleChoseFileClick);
    document.querySelector("#send").addEventListener("click",handleSendFileClick);
    document.querySelector("#json").addEventListener("click",handleSendJsonClick);
}

window.addEventListener("DOMContentLoaded",init);