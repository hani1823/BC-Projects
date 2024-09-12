page 50106 "Correct GL "
{

    PageType = Card;
    ApplicationArea = all;
    UsageCategory = Administration;
    Permissions = tabledata "G/L Entry" = RMID;
    Caption = 'Correct GL ';
    actions
    {

        area(Processing)
        {
            action("Correct 41020002")
            {
                ApplicationArea = all;
                trigger OnAction()
                var
                    GL: Record "G/L Entry";
                    counter: Integer;
                begin
                    GL.SetRange("G/L Account No.", '41020002');
                    counter := 0;
                    if GL.FindSet() then begin
                        repeat
                            if GL."Global Dimension 2 Code" = '25364' then begin
                                GL."Dimension Set ID" := 121;
                                GL.Modify();
                                counter := counter + 1;
                            end
                            else if GL."Global Dimension 2 Code" = '29667' then begin
                                GL."Dimension Set ID" := 107;
                                GL.Modify();
                                counter := counter + 1;
                            end
                            else if GL."Global Dimension 2 Code" = '24940' then begin
                                GL."Dimension Set ID" := 787;
                                GL.Modify();
                                counter := counter + 1;
                            end
                            else if GL."Global Dimension 2 Code" = 'GEN' then begin
                                GL."Dimension Set ID" := 772;
                                GL.Modify();
                                counter := counter + 1;
                            end
                            else if GL."Global Dimension 2 Code" = '' then begin
                                GL."Dimension Set ID" := 366;
                                GL.Modify();
                                counter := counter + 1;
                            end;

                        until GL.Next() = 0;
                    end;

                    Message('you will mofidify %1 ', counter);
                end;
            }
            action("Correct 41010006")
            {
                ApplicationArea = all;
                trigger OnAction()
                var
                    GL: Record "G/L Entry";
                    counter: Integer;
                begin
                    GL.SetRange("G/L Account No.", '41010006');
                    counter := 0;
                    if GL.FindSet() then begin
                        repeat
                            if GL."Global Dimension 2 Code" = '25364' then begin
                                GL."Dimension Set ID" := 85;
                                GL.Modify();
                                counter := counter + 1;
                            end
                            else if GL."Global Dimension 2 Code" = '29667' then begin
                                GL."Dimension Set ID" := 1677;
                                GL.Modify();
                                counter := counter + 1;
                            end
                            else if GL."Global Dimension 2 Code" = '24940' then begin
                                GL."Dimension Set ID" := 2254;
                                GL.Modify();
                                counter := counter + 1;
                            end
                            else if GL."Global Dimension 2 Code" = 'GEN' then begin
                                GL."Dimension Set ID" := 2113;
                                GL.Modify();
                                counter := counter + 1;
                            end
                            else if GL."Global Dimension 2 Code" = '' then begin
                                GL."Dimension Set ID" := 2118;
                                GL.Modify();
                                counter := counter + 1;
                            end;
                        until GL.Next() = 0;
                    end;

                    Message('you will mofidify %1 ', counter);
                end;
            }
            action("Correct 41020001")
            {
                ApplicationArea = all;
                trigger OnAction()
                var
                    GL: Record "G/L Entry";
                    counter: Integer;
                begin
                    GL.SetRange("G/L Account No.", '41020001');
                    counter := 0;
                    if GL.FindSet() then begin
                        repeat
                            if GL."Global Dimension 2 Code" = '25364' then begin
                                GL."Dimension Set ID" := 1107;
                                GL.Modify();
                                counter := counter + 1;
                            end
                            else if GL."Global Dimension 2 Code" = '29667' then begin
                                GL."Dimension Set ID" := 794;
                                GL.Modify();
                                counter := counter + 1;
                            end
                            else if GL."Global Dimension 2 Code" = '24940' then begin
                                GL."Dimension Set ID" := 2114;
                                GL.Modify();
                                counter := counter + 1;
                            end
                            else if GL."Global Dimension 2 Code" = 'GEN' then begin
                                GL."Dimension Set ID" := 2115;
                                GL.Modify();
                                counter := counter + 1;
                            end
                            else if GL."Global Dimension 2 Code" = '' then begin
                                GL."Dimension Set ID" := 1238;
                                GL.Modify();
                                counter := counter + 1;
                            end;
                        until GL.Next() = 0;
                    end;

                    Message('you will mofidify %1 ', counter);
                end;
            }
            action("Correct 41010004")
            {
                ApplicationArea = all;
                trigger OnAction()
                var
                    GL: Record "G/L Entry";
                    counter: Integer;
                begin
                    GL.SetRange("G/L Account No.", '41010004');
                    counter := 0;
                    if GL.FindSet() then begin
                        repeat
                            if GL."Global Dimension 2 Code" = '25364' then begin
                                GL."Dimension Set ID" := 95;
                                GL.Modify();
                                counter := counter + 1;
                            end
                            else if GL."Global Dimension 2 Code" = '29667' then begin
                                GL."Dimension Set ID" := 89;
                                GL.Modify();
                                counter := counter + 1;
                            end
                            else if GL."Global Dimension 2 Code" = '24940' then begin
                                GL."Dimension Set ID" := 1231;
                                GL.Modify();
                                counter := counter + 1;
                            end
                            else if GL."Global Dimension 2 Code" = 'GEN' then begin
                                GL."Dimension Set ID" := 90;
                                GL.Modify();
                                counter := counter + 1;
                            end
                            else if GL."Global Dimension 2 Code" = 'LAUNDRY' then begin
                                GL."Dimension Set ID" := 2253;
                                GL.Modify();
                                counter := counter + 1;
                            end
                            else if GL."Global Dimension 2 Code" = '' then begin
                                GL."Dimension Set ID" := 400;
                                GL.Modify();
                                counter := counter + 1;
                            end;
                        until GL.Next() = 0;
                    end;

                    Message('you will mofidify %1 ', counter);
                end;
            }
            action("Correct 4 Accounts")
            {
                ApplicationArea = all;
                trigger OnAction()
                var
                    GL: Record "G/L Entry";
                    counter: Integer;
                begin
                    GL.SetFilter("G/L Account No.", '41010001|41010002|41010003|41010010');

                    counter := 0;
                    if GL.FindSet() then begin
                        repeat
                            if GL."Global Dimension 2 Code" = '25364' then begin
                                GL."Dimension Set ID" := 2248;
                                GL.Modify();
                                counter := counter + 1;
                            end
                            else if GL."Global Dimension 2 Code" = '29667' then begin
                                GL."Dimension Set ID" := 2249;
                                GL.Modify();
                                counter := counter + 1;
                            end
                            else if GL."Global Dimension 2 Code" = '24940' then begin
                                GL."Dimension Set ID" := 2250;
                                GL.Modify();
                                counter := counter + 1;
                            end
                            else if GL."Global Dimension 2 Code" = 'GEN' then begin
                                GL."Dimension Set ID" := 2251;
                                GL.Modify();
                                counter := counter + 1;
                            end
                            else if GL."Global Dimension 2 Code" = '' then begin
                                GL."Dimension Set ID" := 2252;
                                GL.Modify();
                                counter := counter + 1;
                            end;
                        until GL.Next() = 0;
                    end;
                    Message('you will mofidify %1 ', counter);
                end;
            }
        }
    }
}