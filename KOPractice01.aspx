<%@ Page Language="C#" AutoEventWireup="true" CodeFile="KOPractice01.aspx.cs" Inherits="_KOPractice01" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
    <head runat="server">
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>KO Practice3 動態新增下拉選單選項</title>
        <script src="Scripts/jquery-2.1.0.min.js"></script>
        <%--<script src="Scripts/knockout-3.0.0.js"></script>--%>
        <script src="Scripts/knockout-3.0.0.debug.js"></script>
        <script type="text/javascript">

            //將ViewModel宣告成function，方便擴充額外功能
            function MyViewModel() {
                /// <summary>ViewModel</summary>

                //由於this在不同範圍代表意義有別，
                //習慣上會用self代表ViewModel本體，不易混淆
                var self = this;
                self.firstName = ko.observable($('#TextBox1').val());
                self.lastName = ko.observable($('#TextBox2').val());

                //使用ko.computed宣告函數，透過運算產生屬性值
                self.fullName = ko.computed(function () {
                    //透過ko.observable宣告的屬性，
                    //要用propName()方式取得最新結果
                    return self.firstName() + " "
                               + self.lastName();
                });

                //宣告一個物件陣列用來提供select的選項
                //self.selectOptions = [
                //        { t: "PCText", v: "PC" },
                //        { t: "Notebook", v: "NB" },
                //        { t: "PhoneText", v: "Phone" }
                //];
                //希望陣列結果變動時能馬上回饋到UI上，則使用ko.observableArray()
                //宣告時先放入一個選項，之後再動態增加
                self.selectOptions = ko.observableArray([
                        { t: "PCText", v: "PC" },
                        { t: "Notebook", v: "NB" },
                        { t: "PhoneText", v: "Phone" }
                ]);

                self.result = ko.observable("PC");
                self.changeToPhone = function () {
                    //ko.observable()宣告的屬性，
                    //使用propName("...")方式改變其值，
                    //才能通知相關UI產生連動效果
                    self.result("Phone");
                };
            }

            //使用new MyViewModel()產生一個ViewModel個體
            $(function () {
                var vm = new MyViewModel();
                ko.applyBindings(vm);

                $("#btnAddOpt").click(function () {
                    //使用observableArray push()增加陣列元素，可即時反應到繫結元素上
                    vm.selectOptions.push({
                        "t": $("#txtOptText").val(),
                        "v": $("#txtOptValue").val()
                    });
                });

            });

        </script>
    </head>
    <body>
        <form runat="server">
            FirstName
            <input type="text" data-bind="value: firstName" />
            LastName
            <input type="text" data-bind="value: lastName" />
            <br />
            <asp:TextBox ID="TextBox1" runat="server" data-bind="value: firstName"></asp:TextBox>
            <asp:TextBox ID="TextBox2" runat="server" data-bind="value: lastName"></asp:TextBox>

            <span data-bind="text: fullName"></span>
        </form>
        <hr />
        <!-- 額外指定options來源，option text/value對應的屬性名稱 -->
        <select
            data-bind="options: selectOptions, optionsText: 't', optionsValue: 'v', value: result">
        </select><br />
        <span data-bind="text: result"></span>
        <br />
        <!-- 指定按鈕click事件呼叫ViewModel中的特定函數修改result值 -->
        <input type="button" value="Set Phone" data-bind="click: changeToPhone" />
        <hr />
        <div>
            <select id="selOptions" style="width: 120px"
                data-bind="options: selectOptions, optionsText: 't', optionsValue: 'v', value: result">
            </select>
            Result=<span data-bind="text: result"></span>
        </div>
        <div style="margin-top: 10px">
            Text:
            <input id='txtOptText' value="PC" />
            Value:
            <input id='txtOptValue' value="PC" />
            &nbsp; 
            <input type="button" value="新增選項" id='btnAddOpt' />
        </div>
    </body>
</html>
